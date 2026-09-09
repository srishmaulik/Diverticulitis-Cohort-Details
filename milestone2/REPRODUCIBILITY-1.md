# Milestone 2 — Reproducibility Documentation

This document contains every step, command, and script needed to reproduce
the Milestone 2 analysis end to end: note extraction, pattern matching, and
3-model LLM inference (Qwen on Core HPC, OpenBioLLM and Mistral on AWS EC2),
through to the final merged analysis.

## Environment Overview

| Component | Environment | Access Method |
|---|---|---|
| Cohort/note extraction, pattern matching | AWS Athena (`sguhamaulik` schema) | UCSF Athena console |
| Qwen2.5-7B-Instruct inference | UCSF Core HPC (SLURM, L40 GPU) | SSH via bastion + login node |
| Llama-3-OpenBioLLM-8B inference | UCSF Core HPC (SLURM, L40 GPU) | SSH via bastion + login node |
| Mistral-7B-Instruct inference | AWS EC2 (`g5.2xlarge`, IC Secure) | OpenCode → bastion → SSH |
| Final merge & analysis | Local machine | Python/pandas |

All patient-level data remained within UCSF's de-identified, access-controlled
environments (Athena's `deid_omop`/`deid_cdw_ucsf` schemas, Core HPC scratch
storage, and the IC-Secure EC2 environment) throughout the pipeline.

---

## Step 1: Cohort & Note Extraction (Athena)

Builds the 511-candidate cohort (311 treatment + 200 sampled baseline),
extracts Progress Notes within a 7-day window per patient, and stores the
result as `sguhamaulik.notes_extraction_m2`.

```sql
CREATE TABLE sguhamaulik.notes_extraction_m2
WITH (
  format = 'PARQUET'
) AS
WITH Codesets AS (
  SELECT 0 as codeset_id, c.concept_id FROM (
    SELECT distinct I.concept_id FROM (
      SELECT concept_id FROM deid_omop.concept WHERE concept_id in (77025)
      UNION
      SELECT c.concept_id FROM deid_omop.concept c
      JOIN deid_omop.concept_ancestor ca on c.concept_id = ca.descendant_concept_id
      WHERE c.invalid_reason is null AND ca.ancestor_concept_id in (77025)
    ) I
  ) C
  UNION ALL
  SELECT 1 as codeset_id, c.concept_id FROM (
    SELECT distinct I.concept_id FROM (
      SELECT concept_id FROM deid_omop.concept WHERE concept_id in (40105044,40131073,40131077,40105046)
      UNION
      SELECT c.concept_id FROM deid_omop.concept c
      JOIN deid_omop.concept_ancestor ca on c.concept_id = ca.descendant_concept_id
      WHERE c.invalid_reason is null AND ca.ancestor_concept_id in (40105044,40131073,40131077,40105046)
    ) I
  ) C
),
qualified_events AS (
  SELECT pe.event_id, pe.person_id, pe.start_date, pe.end_date, pe.op_start_date, pe.op_end_date,
         row_number() over (partition by pe.person_id order by pe.start_date ASC) as ordinal
  FROM (
    SELECT P.ordinal as event_id, P.person_id, P.start_date, P.end_date, op_start_date, op_end_date
    FROM (
      SELECT E.person_id, E.start_date, E.end_date,
             row_number() OVER (PARTITION BY E.person_id ORDER BY E.sort_date ASC, E.event_id) ordinal,
             OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
      FROM (
        SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date, C.start_date as sort_date
        FROM (
          SELECT co.person_id, co.condition_occurrence_id, co.condition_concept_id,
                 co.condition_start_date as start_date,
                 COALESCE(co.condition_end_date, date_add('day', 1, co.condition_start_date)) as end_date
          FROM deid_omop.condition_occurrence co
          JOIN Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 0)
        ) C
      ) E
      JOIN deid_omop.observation_period OP on E.person_id = OP.person_id
           AND E.start_date >= OP.observation_period_start_date
           AND E.start_date <= op.observation_period_end_date
    ) P
    WHERE P.ordinal = 1
  ) pe
),
Inclusion_0 AS (
  SELECT pe.person_id, pe.event_id
  FROM qualified_events pe
  JOIN deid_omop.person P ON P.person_id = pe.person_id
  WHERE year(pe.start_date) - P.year_of_birth >= 18
),
drug_hits AS (
  SELECT P.person_id, P.event_id, MIN(A.start_date) AS drug_start_date
  FROM qualified_events P
  JOIN (
    SELECT de.person_id, de.drug_exposure_start_date as start_date
    FROM deid_omop.drug_exposure de
    JOIN Codesets cs on (de.drug_concept_id = cs.concept_id and cs.codeset_id = 1)
  ) A on A.person_id = P.person_id
     AND A.start_date >= P.op_start_date AND A.start_date <= P.op_end_date
     AND A.start_date >= P.start_date AND A.start_date <= date_add('day', 14, P.start_date)
  GROUP BY P.person_id, P.event_id
),
treatment_cohort AS (
  SELECT i0.person_id AS subject_id, dh.drug_start_date AS start_date,
         'treatment' AS cohort_group
  FROM Inclusion_0 i0
  JOIN qualified_events qe ON qe.person_id = i0.person_id AND qe.event_id = i0.event_id
  JOIN drug_hits dh ON dh.person_id = i0.person_id AND dh.event_id = i0.event_id
),
baseline_pool AS (
  SELECT i0.person_id AS subject_id, qe.start_date AS start_date,
         'baseline' AS cohort_group
  FROM Inclusion_0 i0
  JOIN qualified_events qe ON qe.person_id = i0.person_id AND qe.event_id = i0.event_id
  WHERE i0.person_id NOT IN (SELECT person_id FROM drug_hits)
),
baseline_sample AS (
  SELECT * FROM baseline_pool
  ORDER BY abs(from_big_endian_64(xxhash64(to_utf8(cast(subject_id as varchar)))))
  LIMIT 200
),
cohort_for_notes AS (
  SELECT * FROM treatment_cohort
  UNION ALL
  SELECT * FROM baseline_sample
),
notes_final AS (
  SELECT
    cfn.subject_id,
    cfn.cohort_group,
    cfn.start_date,
    nm.deid_note_key,
    nm.note_type,
    nm.deid_service_date,
    nt.note_text
  FROM cohort_for_notes cfn
  JOIN deid_omop.person p ON cfn.subject_id = p.person_id
  JOIN deid_cdw_ucsf.patientdim pd
    ON p.person_source_value = pd.patientepicid AND pd.iscurrent = 1
  JOIN deid_cdw_ucsf.note_metadata nm
    ON pd.patientdurablekey = nm.patientdurablekey
  JOIN deid_cdw_ucsf.note_text nt
    ON nm.deid_note_key = nt.deid_note_key
  WHERE nm.note_type = 'Progress Notes'
    AND nm.deid_service_date >= cfn.start_date
    AND nm.deid_service_date <= date_add('day', 7, cfn.start_date)
)
SELECT * FROM notes_final;
```

**Design notes:**
- Treatment cohort window anchors to `drug_start_date`; baseline anchors to
  `diagnosis_date` (start_date), since baseline patients have no drug date.
- `baseline_sample` uses `xxhash64` (Trino/Athena's hash function) for a
  deterministic 200-patient sample — reproducible on every rerun.
- Result: 771 notes across 268 patients (172/311 treatment, 96/200 baseline).

---

## Step 2/3: Pattern Matching (Athena)

```sql
CREATE TABLE sguhamaulik.diverticulitis_pattern_match
WITH (format = 'PARQUET') AS
SELECT
  subject_id, cohort_group, start_date, deid_note_key, note_type, deid_service_date,
  regexp_like(lower(note_text), 'diverticulit') AS pattern_match
FROM sguhamaulik.notes_extraction_m2;

CREATE TABLE sguhamaulik.drug_pattern_match
WITH (format = 'PARQUET') AS
SELECT
  subject_id, cohort_group, start_date, deid_note_key, note_type, deid_service_date,
  regexp_like(lower(note_text), 'amoxicillin|clavulanate|augmentin') AS pattern_match
FROM sguhamaulik.notes_extraction_m2;
```

---

## Step 2/3: LLM Inference — Model 1: Qwen2.5-7B-Instruct (Core HPC)

### One-time environment setup (login node)
```bash
ssh sguhamaulik@chpc-ucsf-bastion-vm1.corehpc.ucsf.edu
ssh chpc-ucsf-login-vm1

cd /mnt/scratch/user/$USER
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh -b -p /mnt/scratch/user/$USER/miniforge3
source /mnt/scratch/user/$USER/miniforge3/etc/profile.d/conda.sh
conda create -y -n m2_env python=3.11
conda activate m2_env
pip install torch transformers vllm pandas pyarrow huggingface_hub

python -c "
from huggingface_hub import snapshot_download
snapshot_download(repo_id='Qwen/Qwen2.5-7B-Instruct',
                   local_dir='/mnt/scratch/user/$USER/models/qwen2.5-7b-instruct')
"

mkdir -p /mnt/scratch/user/$USER/milestone2/{input,output,logs}
```
Note table `notes_extraction_m2` was exported from Athena (Download results
CSV) as `notes_for_inference.csv` and copied into
`/mnt/scratch/user/$USER/milestone2/input/`.

### `qwen_infer.py`
```python
import argparse
import os
import pandas as pd
from vllm import LLM, SamplingParams

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", required=True, choices=["diverticulitis", "drug"])
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--model_dir", default="/mnt/scratch/user/sguhamaulik/models/qwen2.5-7b-instruct")
    args = parser.parse_args()

    df = pd.read_csv(args.input) if args.input.endswith(".csv") else pd.read_parquet(args.input)
    print(f"Loaded {len(df)} notes from {args.input}. Initializing vLLM...")

    llm = LLM(
        model=args.model_dir,
        tensor_parallel_size=1,
        trust_remote_code=True,
        gpu_memory_utilization=0.90,
        max_model_len=4096,
        enforce_eager=True  # avoids Torch Inductor/Triton JIT compile crash on this node
    )
    sampling_params = SamplingParams(temperature=0.0, max_tokens=32)

    prompts = []
    for _, row in df.iterrows():
        text = str(row.get("note_text", ""))[:3000]
        if args.task == "diverticulitis":
            prompt = (
                "<|im_start|>system\nYou are an expert clinical annotator. Respond with only YES or NO.<|im_end|>\n"
                "<|im_start|>user\nDoes this clinical note mention diverticulitis or related diverticular disease?\n\n"
                f"Note:\n{text}<|im_end|>\n<|im_start|>assistant\n"
            )
        else:
            prompt = (
                "<|im_start|>system\nYou are an expert clinical annotator. Respond with only YES or NO.<|im_end|>\n"
                "<|im_start|>user\nDoes this clinical note mention the patient receiving, being "
                "prescribed, or currently taking amoxicillin-clavulanate (also called Augmentin, "
                f"amox-clav, or amoxicillin/clavulanate)?\n\nNote:\n{text}<|im_end|>\n<|im_start|>assistant\n"
            )
        prompts.append(prompt)

    print(f"Running batch inference for {args.task}...")
    outputs = llm.generate(prompts, sampling_params)
    preds = [out.outputs[0].text.strip() for out in outputs]

    df[f"{args.task}_qwen_pred"] = preds
    os.makedirs(os.path.dirname(args.output) or ".", exist_ok=True)
    df.to_parquet(args.output, index=False)
    print(f"Finished successfully. Saved to {args.output}")

if __name__ == "__main__":
    main()
```

### `run_qwen_inference.slurm`
```bash
#!/bin/bash
#SBATCH --job-name=qwen_m2
#SBATCH --output=/mnt/scratch/user/%u/milestone2/logs/qwen_%j.out
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00

# Standard system GCC — NVIDIA HPC SDK's nvc fails on -Wno-psabi during
# vLLM/Triton's runtime kernel compilation
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++

# FlashInfer's sampler needs nvcc, unavailable on this node — use vLLM's
# native sampler instead (no accuracy cost for temperature=0.0)
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_USE_V1=0
export TORCH_COMPILE_DISABLE=1
export TRITON_CACHE_DIR=/mnt/scratch/user/$USER/.triton_cache
export TORCHINDUCTOR_CACHE_DIR=/mnt/scratch/user/$USER/.torch_cache

source /mnt/scratch/user/$USER/miniforge3/etc/profile.d/conda.sh
conda activate m2_env

python /mnt/scratch/user/$USER/milestone2/qwen_infer.py "$@"
```

### Submission
```bash
cd /mnt/scratch/user/$USER/milestone2
sbatch run_qwen_inference.slurm --task diverticulitis \
  --input input/notes_for_inference.csv --output output/diverticulitis_qwen_results.parquet
sbatch run_qwen_inference.slurm --task drug \
  --input input/notes_for_inference.csv --output output/drug_qwen_results.parquet
# monitor:
squeue -u $USER
tail -f logs/qwen_*.out
```
Results (`deid_note_key`, `diverticulitis_qwen_pred` / `drug_qwen_pred`,
`note_text`, etc.) downloaded via `scp` to the local analysis folder.

---

## Step 2/3: LLM Inference — Model 2: Llama-3-OpenBioLLM-8B (Core HPC)

OpenBioLLM was initially set up to run on EC2, but moved to Core HPC
partway through (same already-working conda/vLLM environment as Qwen,
faster job turnaround than a fresh EC2 boot). All results used in the
final analysis come from this Core HPC run.

### One-time setup (login node, `m2_env` already created for Qwen)
```bash
python -c "
from huggingface_hub import snapshot_download
snapshot_download(repo_id='aaditya/Llama3-OpenBioLLM-8B',
                   local_dir='/mnt/scratch/user/$USER/models/openbiollm-8b')
"
```

### `openbiollm_infer_v2.py` (final version — structured decoding)
```python
import argparse
import os
import pandas as pd
from vllm import LLM, SamplingParams
from vllm.sampling_params import StructuredOutputsParams


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", required=True, choices=["diverticulitis", "drug"])
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--model_dir", default="/mnt/scratch/user/sguhamaulik/models/openbiollm-8b")
    args = parser.parse_args()

    df = pd.read_csv(args.input) if args.input.endswith(".csv") else pd.read_parquet(args.input)
    print(f"Loaded {len(df)} notes from {args.input}. Initializing vLLM...")

    llm = LLM(
        model=args.model_dir,
        tensor_parallel_size=1,
        trust_remote_code=True,
        gpu_memory_utilization=0.90,
        max_model_len=4096,
        enforce_eager=True,
    )
    sampling_params = SamplingParams(
        temperature=0.0,
        max_tokens=10,
        structured_outputs=StructuredOutputsParams(choice=["YES", "NO"]),
    )

    prompts = []
    for _, row in df.iterrows():
        text = str(row.get("note_text", ""))[:3000]
        if args.task == "diverticulitis":
            user_msg = (
                "Does this clinical note mention diverticulitis or related "
                f"diverticular disease?\n\nNote:\n{text}"
            )
        else:
            user_msg = (
                "Does this clinical note mention the patient receiving, being "
                "prescribed, or currently taking amoxicillin-clavulanate (also "
                f"called Augmentin, amox-clav, or amoxicillin/clavulanate)?\n\nNote:\n{text}"
            )
        prompt = (
            "<|begin_of_text|><|start_header_id|>system<|end_header_id|>\n\n"
            "You are an expert clinical annotator. Answer with YES or NO only."
            "<|eot_id|><|start_header_id|>user<|end_header_id|>\n\n"
            f"{user_msg}<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n"
        )
        prompts.append(prompt)

    print(f"Running batch inference for {args.task}...")
    outputs = llm.generate(prompts, sampling_params)
    results = [out.outputs[0].text.strip() for out in outputs]
    print(f"Results: {results.count('YES')} YES, {results.count('NO')} NO (out of {len(results)})")

    df[f"{args.task}_llm_result"] = results
    df["model_name"] = "OpenBioLLM-v2"
    os.makedirs(os.path.dirname(args.output) or ".", exist_ok=True)
    df.to_parquet(args.output, index=False)
    print(f"Finished successfully. Saved to {args.output}")


if __name__ == "__main__":
    main()
```

### `run_openbiollm_v2.slurm`
Identical to `run_qwen_inference.slurm`, generated by substituting the
Python entrypoint (same compiler fixes, same cache-dir redirects, same
`VLLM_USE_FLASHINFER_SAMPLER=0` workaround apply):
```bash
sed 's/qwen_infer.py/openbiollm_infer_v2.py/' run_qwen_inference.slurm > run_openbiollm_v2.slurm
```

### Submission
```bash
sbatch run_openbiollm_v2.slurm --task diverticulitis \
  --input input/notes_for_inference.csv --output output/diverticulitis_openbiollm_v2_results.parquet
sbatch run_openbiollm_v2.slurm --task drug \
  --input input/notes_for_inference.csv --output output/drug_openbiollm_v2_results.parquet
squeue -u $USER
tail -f logs/qwen_*.out
```
Results downloaded via `scp` to the local analysis folder.

**Note on iteration:** an earlier OpenBioLLM run without structured decoding
produced unreliable free-text answers (full sentences instead of YES/NO,
including truncated responses under a 32-token cap) that a downstream
parser struggled to interpret consistently. Switching to
`StructuredOutputsParams` — which constrains the model's actual token
generation rather than relying on prompt-following — resolved this
completely; the results included in the final analysis are from this
corrected run.

---

## Step 2/3: LLM Inference — Model 3: Mistral-7B-Instruct (AWS EC2, IC Secure)

### Instance configuration
`configuration/myec2instance.json`:
```json
"InstanceType": "g5.2xlarge",
"VolumeSize": "100"
```
(1× NVIDIA A10G, 24GB VRAM — sufficient for a 7B model in bf16)

### Launch and connect (via OpenCode, using the project's EC2 tooling)
```bash
python start-instance.py     # ~15 min first boot
python login-instance.py
./RUNME
```

### One-time environment setup (on the instance)
```bash
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh -b -p ~/miniforge3
source ~/miniforge3/etc/profile.d/conda.sh
conda create -y -n m2_env python=3.11
conda activate m2_env
pip install torch transformers vllm pandas pyarrow huggingface_hub

python -c "
from huggingface_hub import snapshot_download
snapshot_download(repo_id='mistralai/Mistral-7B-Instruct-v0.3', local_dir='/home/ubuntu/models/mistral-7b-instruct')
"
```
`notes_for_inference.csv` copied to the instance the same way as the HPC input.

### `mistral_infer.py` (prompt-based constraint — regex-parsed output)
```python
import argparse
import os
import re
import pandas as pd
from vllm import LLM, SamplingParams

NEGATIVE_PATTERNS = [
    "does not mention", "is not receiving", "is not currently", "is not taking",
    "is not prescribed", "was not prescribed", "no evidence", "denies", "not on",
]
POSITIVE_PATTERNS = [
    "does mention", "mentions the patient", "is currently", "is receiving",
    "is prescribed", "is taking", "was prescribed", "was given",
]


def parse_response(raw_text):
    text = raw_text.strip().lower()
    if re.search(r"^\s*yes\b", text):
        return "YES"
    if re.search(r"^\s*no\b", text):
        return "NO"
    for pat in NEGATIVE_PATTERNS:
        if pat in text:
            return "NO"
    for pat in POSITIVE_PATTERNS:
        if pat in text:
            return "YES"
    return "UNCLEAR"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", required=True, choices=["diverticulitis", "drug"])
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--model_dir", default="/home/ubuntu/models/mistral-7b-instruct")
    args = parser.parse_args()

    df = pd.read_csv(args.input) if args.input.endswith(".csv") else pd.read_parquet(args.input)
    print(f"Loaded {len(df)} notes from {args.input}. Initializing vLLM...")

    llm = LLM(
        model=args.model_dir,
        tensor_parallel_size=1,
        trust_remote_code=True,
        gpu_memory_utilization=0.90,
        max_model_len=4096,
        enforce_eager=True,
    )
    sampling_params = SamplingParams(temperature=0.0, max_tokens=128)

    prompts = []
    for _, row in df.iterrows():
        text = str(row.get("note_text", ""))[:3000]
        if args.task == "diverticulitis":
            user_msg = (
                "Does this clinical note mention diverticulitis or related "
                f"diverticular disease?\n\nNote:\n{text}"
            )
        else:
            user_msg = (
                "Does this clinical note mention the patient receiving, being "
                "prescribed, or currently taking amoxicillin-clavulanate (also "
                f"called Augmentin, amox-clav, or amoxicillin/clavulanate)?\n\nNote:\n{text}"
            )
        # Mistral instruct chat template (not Llama-3 header tokens)
        prompt = f"[INST] You are an expert clinical annotator. Answer with YES or NO only.\n\n{user_msg} [/INST]"
        prompts.append(prompt)

    print(f"Running batch inference for {args.task}...")
    outputs = llm.generate(prompts, sampling_params)
    raw_responses = [out.outputs[0].text.strip() for out in outputs]
    parsed_results = [parse_response(r) for r in raw_responses]
    print(f"Parsed {len(parsed_results)} responses: "
          f"{parsed_results.count('YES')} YES, "
          f"{parsed_results.count('NO')} NO, "
          f"{parsed_results.count('UNCLEAR')} UNCLEAR")

    df[f"{args.task}_llm_result"] = parsed_results
    df["model_name"] = "Mistral-7B-Instruct-v0.3"
    os.makedirs(os.path.dirname(args.output) or ".", exist_ok=True)
    df.to_parquet(args.output, index=False)
    print(f"Finished successfully. Saved to {args.output}")


if __name__ == "__main__":
    main()
```

**Note on methodology:** unlike OpenBioLLM, Mistral was not run with
`StructuredOutputsParams`-enforced decoding — it used a prompt-based
instruction plus regex/sentence-pattern parsing of the raw output. This
was sufficient for Mistral specifically because its raw responses were
consistently clean YES/NO (or clearly parseable full-sentence) answers,
with no truncation or hallucination observed on manual review — the
structured-decoding fix was only necessary for OpenBioLLM, which
exhibited a genuine calibration problem that persisted regardless of
output-format enforcement. Mistral's results in this repository come
from this prompt-based run; no structured-decoding rerun was performed.

### Run and retrieve
```bash
python mistral_infer.py --task diverticulitis \
  --input notes_for_inference.csv --output diverticulitis_mistral_results.parquet
python mistral_infer.py --task drug \
  --input notes_for_inference.csv --output drug_mistral_results.parquet
```
Results downloaded via `scp` from a local terminal (not from within the
instance) to the local analysis folder, then:
```bash
python stop-instance.py   # stop billing once done
```

---

## Combining Results (Athena + Local)

### Demographics + pattern-match baseline export (Athena)
```sql
SELECT
    n.deid_note_key,
    n.subject_id,
    n.cohort_group,
    n.start_date,
    p.gender_source_value AS gender,
    p.race_source_value AS race,
    p.ethnicity_source_value AS ethnicity,
    YEAR(n.start_date) - p.year_of_birth AS age,
    dpm.pattern_match AS div_baseline,
    drm.pattern_match AS drug_baseline
FROM sguhamaulik.notes_extraction_m2 n
JOIN deid_omop.person p ON n.subject_id = p.person_id
LEFT JOIN sguhamaulik.diverticulitis_pattern_match dpm ON n.deid_note_key = dpm.deid_note_key
LEFT JOIN sguhamaulik.drug_pattern_match drm ON n.deid_note_key = drm.deid_note_key;
```
Downloaded as `athena_pattern_matched.csv`.

### Local merge & analysis (`milestone2_step4_5.py`)
Loads all 6 model result files (auto-detecting each file's prediction
column), loads the Athena export, merges everything to note level, rolls
up to patient level (a patient is YES for a method if *any* of their notes
were YES), then prints Table 1s (age/gender/race/ethnicity by
method-and-concept) and Step 5 agreement crosstabs (each model vs.
pattern-match baseline, plus a cohort-group split for the drug task).

```bash
pip install pandas
python milestone2_step4_5.py
```
Full script contents: see `milestone2_step4_5.py` in this repository.

Output: `patient_level_merged_results.csv` — the final 268-patient,
one-row-per-patient table underlying every figure in the write-up.

---

## Reproducing From Scratch

1. Run the Step 1 SQL to build `notes_extraction_m2` (~771 notes).
2. Run the Step 2/3 pattern-match SQL (2 tables).
3. Run Qwen inference on Core HPC (2 SLURM jobs).
4. Run OpenBioLLM inference on Core HPC (2 SLURM jobs).
5. Run Mistral inference on EC2 (2 runs).
6. Run the Athena demographics/baseline export query, download as CSV.
7. Place all result files in one local folder and run `milestone2_step4_5.py`.
8. Table 1s and Step 5 comparisons print to console and save to
   `patient_level_merged_results.csv`.

All SQL and Python scripts in this document are the exact versions used to
produce the results in the final write-up.
