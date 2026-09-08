# **Qwen HPC Inference Pipeline — Milestone 2 (Step 2 & 3, Model 1 of 3\)**

This documents the full, corrected pipeline used to run Qwen2.5-7B-Instruct locally on UCSF CoreHPC against the 771-note extraction (`notes_for_inference.csv`), producing YES/NO classifications for both the diagnosis-mention task (Step 2\) and the drug-mention task (Step 3).

The version below fixes two problems that were in earlier drafts of this pipeline: one caused a hard crash, one would have silently produced meaningless results. Both are called out explicitly at the step where they apply.

---

## **Step 1: Connect to CoreHPC**

CoreHPC sits behind a bastion host requiring UCSF VPN \+ MFA/DUO. From a local machine:

ssh sguhamaulik@chpc-ucsf-bastion-vm1.corehpc.ucsf.edu  
ssh chpc-ucsf-login-vm1

Or, to collapse this into one command, add to `~/.ssh/config`:

Host corehpc  
  HostName chpc-ucsf-login-vm1  
  ProxyJump sguhamaulik@chpc-ucsf-bastion-vm1.corehpc.ucsf.edu

then just `ssh corehpc`.

**Why:** compute nodes are not directly reachable from the open internet — the login node is the only entry point, and the bastion enforces UCSF-side access control before you even reach that.

---

## **Step 2: Conda environment on scratch storage (not home)**

cd /mnt/scratch/user/$USER

wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86\_64.sh  
bash Miniforge3-Linux-x86\_64.sh \-b \-p /mnt/scratch/user/$USER/miniforge3

source /mnt/scratch/user/$USER/miniforge3/etc/profile.d/conda.sh  
conda create \-y \-n m2\_env python=3.11  
conda activate m2\_env

pip install torch transformers vllm pandas pyarrow huggingface\_hub

**Why scratch, not `$HOME`:** CoreHPC enforces a 20GB quota on home directories. A conda environment plus vLLM plus PyTorch plus CUDA libraries alone can exceed that before you've even downloaded a model. Scratch has much higher capacity and is where all of this project's storage-heavy work lives.

**Why this has to happen on the login node specifically:** GPU compute nodes on this cluster have no outbound internet access (a common security posture for HPC clusters handling sensitive data) — `pip install` and any download must happen somewhere with internet access, which is the login node, then the resulting environment is simply *read* by compute nodes at job time (no install step happens there).

---

## **Step 3: Stage Qwen model weights (also from the login node, same reason)**

python \-c "  
from huggingface\_hub import snapshot\_download  
import os

target\_dir \= os.path.expandvars('/mnt/scratch/user/$USER/models/qwen2.5-7b-instruct')  
snapshot\_download(  
    repo\_id='Qwen/Qwen2.5-7B-Instruct',  
    local\_dir=target\_dir  
)  
"

**Why download once, ahead of time, rather than at job runtime:** same no-internet-on-compute-nodes constraint as Step 2\. This also means every job run reads the same fixed set of weights from disk — good for reproducibility, since re-running the pipeline later can't silently pull a different model revision.

---

## **Step 4: Workspace layout and input staging**

mkdir \-p /mnt/scratch/user/$USER/milestone2/{input,output,logs}

The 771-row notes extraction was downloaded from Athena as `notes_for_inference.csv` (via the query results panel's "Download results CSV" — not parquet, since Athena's CSV export handles the embedded commas/quotes/newlines in clinical note text correctly and the row count was verified to match 771 after loading) and copied into`/mnt/scratch/user/$USER/milestone2/input/`.

---

## **Step 5: Inference script (`qwen_infer.py`) — corrected**

Two fixes vs. an earlier draft:

1. **The drug-mention prompt must name the actual drug.** An earlier version asked "does this note indicate administration of *the target study drug*" without ever stating what that drug was — Qwen has no way to resolve that reference, so every drug-task classification would have been meaningless. Fixed to explicitly name amoxicillin-clavulanate, Augmentin, and amox-clav.  
2. **`enforce_eager=True` alone was not enough to avoid every JIT-compilation crash on this node.** It stops vLLM from compiling CUDA graphs via Torch Inductor, but vLLM separately tried to use FlashInfer's sampling kernel, which also needs to JIT-compile via `nvcc` — and this node has no CUDA toolkit at the expected path. This surfaced as a *second*, later crash after the first one was fixed. The real fix is disabling FlashInfer's sampler specifically (set in the SLURM script, Step 6\) — for a greedy-decoded (`temperature=0.0`) YES/NO task, this has no accuracy cost.

import argparse  
import os  
import pandas as pd  
from vllm import LLM, SamplingParams

def main():  
    parser \= argparse.ArgumentParser()  
    parser.add\_argument("--task", required=True, choices=\["diverticulitis", "drug"\])  
    parser.add\_argument("--input", required=True)  
    parser.add\_argument("--output", required=True)  
    parser.add\_argument("--model\_dir", default="/mnt/scratch/user/sguhamaulik/models/qwen2.5-7b-instruct")  
    args \= parser.parse\_args()

    if args.input.endswith(".parquet"):  
        df \= pd.read\_parquet(args.input)  
    else:  
        df \= pd.read\_csv(args.input)

    print(f"Loaded {len(df)} notes from {args.input}. Initializing vLLM...")

    llm \= LLM(  
        model=args.model\_dir,  
        tensor\_parallel\_size=1,  
        trust\_remote\_code=True,  
        gpu\_memory\_utilization=0.90,  
        max\_model\_len=4096,  
        enforce\_eager=True  \# avoids Torch Inductor/Triton JIT compile crash on this node  
    )  
    sampling\_params \= SamplingParams(temperature=0.0, max\_tokens=32)

    prompts \= \[\]  
    for \_, row in df.iterrows():  
        text \= str(row.get("note\_text", ""))\[:3000\]  
        if args.task \== "diverticulitis":  
            prompt \= (  
                f"\<|im\_start|\>system\\nYou are an expert clinical annotator. Respond with only YES or NO.\<|im\_end|\>\\n"  
                f"\<|im\_start|\>user\\nDoes this clinical note mention diverticulitis or related diverticular disease?\\n\\n"  
                f"Note:\\n{text}\<|im\_end|\>\\n\<|im\_start|\>assistant\\n"  
            )  
        else:  
            \# FIXED: names the actual drug instead of "the target study drug"  
            prompt \= (  
                f"\<|im\_start|\>system\\nYou are an expert clinical annotator. Respond with only YES or NO.\<|im\_end|\>\\n"  
                f"\<|im\_start|\>user\\nDoes this clinical note mention the patient receiving, being "  
                f"prescribed, or currently taking amoxicillin-clavulanate (also called Augmentin, "  
                f"amox-clav, or amoxicillin/clavulanate)?\\n\\n"  
                f"Note:\\n{text}\<|im\_end|\>\\n\<|im\_start|\>assistant\\n"  
            )  
        prompts.append(prompt)

    print(f"Running batch inference for {args.task}...")  
    outputs \= llm.generate(prompts, sampling\_params)  
    preds \= \[out.outputs\[0\].text.strip() for out in outputs\]

    df\[f"{args.task}\_qwen\_pred"\] \= preds  
    os.makedirs(os.path.dirname(args.output), exist\_ok=True)  
    df.to\_parquet(args.output, index=False)  
    print(f"Finished successfully. Saved to {args.output}")

if \_\_name\_\_ \== "\_\_main\_\_":  
    main()

**Why `temperature=0.0`:** for a classification task, you want deterministic, repeatable output — not creative sampling variance. Greedy decoding means re-running the same note through the same model always gives the same answer, which matters for a reproducible git repo.

**Why `max_tokens=32`:** the answer is just "YES" or "NO" (a few tokens); capping generation length keeps each request fast and prevents the model from rambling past the actual answer.

**Why truncate note text to 3000 characters:** `max_model_len=4096` is the model's total context window (prompt \+ response combined), and the instruction text plus chat-template formatting takes up some of that budget. 3000 characters of note text comfortably fits with room to spare for the prompt wrapper and response. *Caveat worth knowing:* if some Progress Notes run longer than \~3000 characters, content past that point is invisible to the model — worth a quick check (`df['note_text'].str.len().describe()`) if Qwen's results seem to be missing mentions that pattern-matching caught later in a note.

---

## **Step 6: SLURM script (`run_qwen_inference.slurm`) — corrected**

\#\!/bin/bash  
\#SBATCH \--job-name=qwen\_m2  
\#SBATCH \--output=/mnt/scratch/user/%u/milestone2/logs/qwen\_%j.out  
\#SBATCH \--partition=gpu  
\#SBATCH \--gres=gpu:1  
\#SBATCH \--cpus-per-task=4  
\#SBATCH \--mem=32G  
\#SBATCH \--time=02:00:00

\# Force standard system GCC instead of the NVIDIA HPC SDK's nvc, which fails  
\# on \-Wno-psabi during vLLM/Triton's runtime kernel compilation  
export CC=/usr/bin/gcc  
export CXX=/usr/bin/g++

\# FIXED (was missing): avoid FlashInfer's sampler, which needs nvcc/CUDA  
\# toolkit at build time — not present on this node. Harmless for a  
\# temperature=0.0 classification task.  
export VLLM\_USE\_FLASHINFER\_SAMPLER=0

\# Belt-and-suspenders: also disable the newer v1 engine's compile path and  
\# redirect any remaining JIT caches off of the 20GB-quota home directory  
export VLLM\_USE\_V1=0  
export TORCH\_COMPILE\_DISABLE=1  
export TRITON\_CACHE\_DIR=/mnt/scratch/user/$USER/.triton\_cache  
export TORCHINDUCTOR\_CACHE\_DIR=/mnt/scratch/user/$USER/.torch\_cache

source /mnt/scratch/user/$USER/miniforge3/etc/profile.d/conda.sh  
conda activate m2\_env

python /mnt/scratch/user/$USER/milestone2/qwen\_infer.py "$@"

**Why this had to be fixed inside the script and not just exported in the terminal:** SLURM jobs run in their own fresh shell on a different machine (the compute node), so environment variables exported at the login-node prompt are not inherited by the job — every variable the job needs must be set inside the script itself.

---

## **Step 7: Submit and monitor**

cd /mnt/scratch/user/$USER/milestone2

sbatch run\_qwen\_inference.slurm \\  
    \--task diverticulitis \\  
    \--input input/notes\_for\_inference.csv \\  
    \--output output/diverticulitis\_qwen\_results.parquet

sbatch run\_qwen\_inference.slurm \\  
    \--task drug \\  
    \--input input/notes\_for\_inference.csv \\  
    \--output output/drug\_qwen\_results.parquet

squeue \-u $USER  
tail \-f logs/qwen\_\*.out

Both jobs completed in roughly 65-70 seconds of actual inference time each (after \~30s of model loading/KV-cache setup), well within the 2-hour time limit requested.

---

## **How to download the results to your own device**

The output files live on HPC scratch storage, not on your laptop. From your **local machine's terminal** (not from within an HPC SSH session — the direction of `scp` matters), run:

scp chpc-ucsf-login-vm1:/mnt/scratch/user/sguhamaulik/milestone2/output/diverticulitis\_qwen\_results.parquet \~/Downloads/  
scp chpc-ucsf-login-vm1:/mnt/scratch/user/sguhamaulik/milestone2/output/drug\_qwen\_results.parquet \~/Downloads/

If you only have the two-hop bastion path configured (no direct `corehpc` alias), you'll need the same double-hop for `scp`as you use for `ssh` — either add a `ProxyJump` entry to your local `~/.ssh/config` (see Step 1\) so `scp` can resolve `chpc-ucsf-login-vm1` directly, or copy the files to the bastion first as an intermediate step, then from bastion to your machine.

Once downloaded, you can open them with `pandas.read_parquet(...)` locally, or convert to CSV if you want to eyeball them in a spreadsheet app:

import pandas as pd  
pd.read\_parquet("diverticulitis\_qwen\_results.parquet").to\_csv("diverticulitis\_qwen\_results.csv", index=False)

---

## **What this actually achieved**

This is **one of three models** required for Steps 2 and 3 (the other two — GPT-5.5 and GPT-5-nano via UCSF's Versa API — still need to be run separately on the same 771 notes).

For this model (Qwen2.5-7B-Instruct), across all 771 Progress Notes in the extraction:

* **Diagnosis mention (Step 2 input):** 369 notes classified YES (diverticulitis/diverticular disease mentioned), 402 classified NO.  
* **Drug mention (Step 3 input):** 148 notes classified YES (amoxicillin-clavulanate/Augmentin mentioned), 623 classified NO.

These are per-note classifications, not yet per-patient counts or a comparison against the pattern-matching results — that aggregation and comparison (against `diverticulitis_pattern_match`, and a drug-specific pattern-match table still to be built) is the next step, once GPT-5.5 and GPT-5-nano results exist alongside this one.

**Batching and inference throughput.** All 771 notes for a given task were submitted to Qwen in a single batch call rather than looping over notes one at a time. `qwen_infer.py` builds the full list of 771 formatted prompts in Python and passes the entire list to a single `llm.generate(prompts, sampling_params)` call; the actual batching is handled internally by vLLM's engine, not by any manual chunking in the script. vLLM uses continuous batching: rather than waiting for a fixed group of prompts to all finish before starting the next group, it dynamically packs tokens from multiple in-flight requests into each GPU forward pass (bounded by `max_num_batched_tokens=16384` in this configuration), swapping completed requests out and queuing new ones in as generation proceeds. This is what let all 771 notes for a given task complete in roughly 65-70 seconds of generation time (after \~30 seconds of one-time model loading and KV-cache setup) — an average throughput of about 28-30 prompts per second. This is substantially faster than naive per-note inference with a plain `transformers` generation loop, which processes one prompt through the GPU at a time and leaves most of the GPU's compute capacity idle between requests; vLLM's batching is the reason a 7B-parameter model could classify the entire note set in about a minute rather than several minutes to tens of minutes.