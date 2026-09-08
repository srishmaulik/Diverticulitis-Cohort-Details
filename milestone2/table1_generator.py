import os
import pandas as pd

BASE_DIR = os.path.expanduser("~/Downloads/milestone2_output")  # adjust if your files live elsewhere

# Map: output column name -> filename
MODEL_FILES = {
    "div_openbio": "diverticulitis_openbiollm_v2_results.csv",
    "div_qwen": "diverticulitis_qwen_results.csv",
    "div_mistral": "diverticulitis_mistral_results.csv",
    "drug_openbio": "drug_openbiollm_v2_results.csv",
    "drug_qwen": "drug_qwen_results.csv",
    "drug_mistral": "drug_mistral_results.csv",
}

# Columns that are metadata, not the prediction itself — used to auto-detect
# whichever remaining column holds the model's YES/NO answer.
KNOWN_METADATA_COLS = {
    "deid_note_key", "subject_id", "cohort_group", "start_date",
    "note_type", "deid_service_date", "note_text", "drug_start_date",
    "diagnosis_date", "model_name",
    "diverticulitis_llm_raw_response", "drug_llm_raw_response",
}

def load_and_extract_prediction(out_name, filename):
    path = os.path.join(BASE_DIR, filename)
    df = pd.read_csv(path)

    if "deid_note_key" not in df.columns:
        raise KeyError(
            f"'{filename}' has no 'deid_note_key' column. "
            f"Actual columns: {list(df.columns)}"
        )

    candidate_cols = [c for c in df.columns if c not in KNOWN_METADATA_COLS]
    if len(candidate_cols) != 1:
        raise KeyError(
            f"Could not auto-detect a single prediction column in '{filename}'. "
            f"Candidates found: {candidate_cols}. "
            f"Edit load_and_extract_prediction() to pick the right one explicitly."
        )
    pred_col = candidate_cols[0]
    print(f"  {out_name}: using column '{pred_col}' from {filename}")

    small = df[["deid_note_key", pred_col]].rename(columns={pred_col: out_name})
    small["deid_note_key"] = small["deid_note_key"].astype(str)
    small[out_name] = small[out_name].astype(str).str.upper().str.strip()
    return small


print("Loading model result files...")
model_frames = {
    out_name: load_and_extract_prediction(out_name, filename)
    for out_name, filename in MODEL_FILES.items()
}

# ==========================================
# LOAD ATHENA EXPORT (baseline + demographics)
# ==========================================
athena_export = pd.read_csv(os.path.join(BASE_DIR, "athena_pattern_matched.csv"))
athena_export["deid_note_key"] = athena_export["deid_note_key"].astype(str)
athena_export["div_baseline"] = athena_export["div_baseline"].astype(str).str.upper().map(
    {"TRUE": "YES", "FALSE": "NO"}
)
athena_export["drug_baseline"] = athena_export["drug_baseline"].astype(str).str.upper().map(
    {"TRUE": "YES", "FALSE": "NO"}
)

# ==========================================
# BUILD NOTE-LEVEL MASTER TABLE
# ==========================================
master_df = athena_export[
    ["deid_note_key", "subject_id", "cohort_group", "gender", "race", "ethnicity", "age",
     "div_baseline", "drug_baseline"]
].copy()

for out_name, df in model_frames.items():
    master_df = master_df.merge(df, on="deid_note_key", how="left")

print(f"\nMaster table: {len(master_df)} note-level rows.")
print(master_df["cohort_group"].value_counts())

# ==========================================
# ROLL UP TO PATIENT LEVEL
# A patient counts as YES for a method if ANY of their notes were YES.
# ==========================================
method_cols = [
    "div_baseline", "div_openbio", "div_qwen", "div_mistral",
    "drug_baseline", "drug_openbio", "drug_qwen", "drug_mistral",
]


def any_yes(series):
    return "YES" if (series == "YES").any() else "NO"


agg_dict = {col: any_yes for col in method_cols}
agg_dict.update({"gender": "first", "race": "first", "ethnicity": "first", "age": "first", "cohort_group": "first"})
patient_df = master_df.groupby("subject_id").agg(agg_dict).reset_index()
print(f"Rolled up to {len(patient_df)} patients.\n")

# ==========================================
# STEP 4: TABLE 1s, per method, at the PATIENT level
# ==========================================
def print_table_1(df, target_col):
    print("\n" + "=" * 60)
    print(f"TABLE 1: Demographics by {target_col} (n={len(df)} patients)")
    print("=" * 60)
    print("\nTotal Count:")
    print(df[target_col].value_counts())
    print("\nAge (Mean +/- SD):")
    print(df.groupby(target_col)["age"].agg(["mean", "std"]).round(2))
    print("\nGender Breakdown (%):")
    print(pd.crosstab(df[target_col], df["gender"], normalize="index").round(3) * 100)
    print("\nRace Breakdown (%):")
    print(pd.crosstab(df[target_col], df["race"], normalize="index").round(3) * 100)


for col in method_cols:
    print_table_1(patient_df, col)

# ==========================================
# STEP 5: AGREEMENT — PATTERN-MATCH BASELINE vs. EACH MODEL
# ==========================================
print("\n" + "=" * 60)
print("STEP 5: Model vs Pattern-Match Baseline — DIAGNOSIS (diverticulitis)")
print("=" * 60)
for model in ["div_openbio", "div_qwen", "div_mistral"]:
    print(f"\n{model} vs. pattern-match baseline:")
    print(pd.crosstab(patient_df["div_baseline"], patient_df[model],
                       rownames=["Pattern Match"], colnames=[model]))

print("\n" + "=" * 60)
print("STEP 5: Model vs Pattern-Match Baseline — DRUG (amox-clav)")
print("=" * 60)
for model in ["drug_openbio", "drug_qwen", "drug_mistral"]:
    print(f"\n{model} vs. pattern-match baseline:")
    print(pd.crosstab(patient_df["drug_baseline"], patient_df[model],
                       rownames=["Pattern Match"], colnames=[model]))

print("\n" + "=" * 60)
print("DRUG MENTIONS SPLIT BY COHORT GROUP (key evidence for Step 5)")
print("=" * 60)
for method in ["drug_baseline", "drug_openbio", "drug_qwen", "drug_mistral"]:
    print(f"\n{method} by cohort_group:")
    print(pd.crosstab(patient_df["cohort_group"], patient_df[method]))


# ==========================================
# SAVE EVERYTHING FOR THE WRITE-UP
# ==========================================
out_path = os.path.join(BASE_DIR, "patient_level_merged_results.csv")
patient_df.to_csv(out_path, index=False)
print(f"\nSaved patient-level merged results to: {out_path}")
