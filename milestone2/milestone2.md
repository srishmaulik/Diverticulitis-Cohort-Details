# Milestone 2: Cohort Validity and Clinical Note Analysis

## Note Extraction Summary

In order to represent a subset of the untreated cohort rather than extracting notes for the full 1,635-patient baseline population, I selected the entire 311-patient treatment cohort plus a random sample of 200 baseline patients as candidates for note extraction (n=511). Of these, only 268 patients (172/311 treatment, 96/200 baseline) had at least one Progress Note within the defined 7-day extraction window; the remaining 243 candidates had no qualifying note in that window and were excluded from the notes-based analysis, yielding 771 total notes (396 from the treatment group, 375 from the baseline group).

---

## Part 1: Structured Cohort Demographics (From Milestone 1)

### 1. Cohort Definition — Qualification Cohort vs. Treatment Cohort

Of the 1,946 qualifying patients, those who additionally received amoxicillin/clavulanate within 14 days of diagnosis were assigned to the treatment cohort: n = 311 patients, with a follow up window of 30 days.

| Demographic Characteristic | Qualification Cohort (n=1,946) | Treatment Cohort (n=311) |
|----------------------------|-------------------------------:|-------------------------:|
| **Gender** | | |
| Female | 974 (50.1%) | 149 (47.9%) |
| Male | 971 (49.9%) | 162 (52.1%) |
| **Race** | | |
| White | 1,289 (66.2%) | 200 (65.8%) |
| Other Races | 275 (14.1%) | 45 (14.8%) |
| Asian | 158 (8.1%) | 41 (13.5%) |
| Black or African American | 106 (5.4%) | 18 (5.9%) |
| Unknown Race | 87 (4.5%) | — (suppressed, n < 11) |
| Native Hawaiian / Pacific Islander | 17 (0.9%) | — (suppressed, n < 11) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 1,536 (78.9%) | 266 (85.5%) |
| Hispanic or Latino | 269 (13.8%) | 38 (12.2%) |
| Unknown Ethnicity | 141 (7.2%) | 7 (2.3%) |

### 2. Cohort Definition — Baseline Cohort vs. Treatment Cohort

The table below compares those who did not take the drug within 14 days (the control/baseline) and those who received amoxicillin/clavulanate.

| Demographic Characteristic | Baseline Cohort (n=1,635) | Treatment Cohort (n=311) |
|----------------------------|--------------------------:|-------------------------:|
| **Gender** | | |
| Female | 825 (50.5%) | 149 (47.9%) |
| Male | 810 (49.5%) | 162 (52.1%) |
| **Race** | | |
| White | 1,089 (66.6%) | 200 (65.8%) |
| Other Races | 230 (14.1%) | 45 (14.8%) |
| Asian | 117 (7.2%) | 41 (13.5%) |
| Black or African American | 88 (5.4%) | 18 (5.9%) |
| Unknown Race | 83 (5.0%) | — |
| Native Hawaiian / Pacific Islander | 15 (0.9%) | — |
| **Ethnicity** | | |
| Not Hispanic or Latino | 1,270 (77.7%) | 266 (85.5%) |
| Hispanic or Latino | 230 (14.1%) | 38 (12.2%) |
| Unknown Ethnicity | 135 (8.2%) | 7 (2.3%) |

### 3. Full Cohort vs. Note-Extraction Sample — Representativeness Check

Since Part 2's analysis covers only the 268-patient subset with an extractable Progress Note (not the full Milestone 1 populations above), the tables below check whether that sampled subset remained demographically representative of its source population.

**Treatment Cohort: Full (n=311) vs. Sampled Subset (n=172)**

| Demographic Characteristic | Full Treatment Cohort (n=311) | Sampled Treatment Subset (n=172) |
|----------------------------|-------------------------------:|----------------------------------:|
| **Gender** | | |
| Female | 149 (47.9%) | 93 (54.1%) |
| Male | 162 (52.1%) | 79 (45.9%) |
| **Race** | | |
| White | 200 (65.8%) | 104 (60.5%) |
| Asian | 41 (13.5%) | 32 (18.6%) |
| Other | 45 (14.8%) | 23 (13.4%) |
| Black or African American | 18 (5.9%) | 9 (5.2%) |
| Declined | — | 2 (1.2%) |
| Other Pacific Islander | — (suppressed) | 1 (0.6%) |
| Unknown | — (suppressed) | 1 (0.6%) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 266 (85.5%) | 146 (84.9%) |
| Hispanic or Latino | 38 (12.2%) | 21 (12.2%) |
| Declined | — | 4 (2.3%) |
| Unknown | 7 (2.3%) | 1 (0.6%) |

**Baseline Cohort: Full (n=1,635) vs. Sampled Subset (n=96)**

| Demographic Characteristic | Full Baseline Pool (n=1,635) | Sampled Baseline Subset (n=96) |
|----------------------------|------------------------------:|---------------------------------:|
| **Gender** | | |
| Female | 825 (50.5%) | 41 (42.7%) |
| Male | 810 (49.5%) | 55 (57.3%) |
| **Race** | | |
| White | 1,089 (66.6%) | 62 (64.6%) |
| Other | 230 (14.1%) | 20 (20.8%) |
| Black or African American | 88 (5.4%) | 7 (7.3%) |
| Asian | 117 (7.2%) | 5 (5.2%) |
| Native American or Alaska Native | — | 2 (2.1%) |
| Unknown | 83 (5.0%) | — |
| Native Hawaiian / Pacific Islander | 15 (0.9%) | — |
| **Ethnicity** | | |
| Not Hispanic or Latino | 1,270 (77.7%) | 76 (79.2%) |
| Hispanic or Latino | 230 (14.1%) | 19 (19.8%) |
| Declined | — | 1 (1.0%) |
| Unknown Ethnicity | 135 (8.2%) | — |

*Note: race/ethnicity categories reflect the raw values returned by the OMOP source table and don't map 1:1 onto Milestone 1's "Other Races"/"Unknown" buckets; small suppressed cells (n<11) from Milestone 1 are shown as "—" and may not be directly comparable to the sampled subset's small-n categories.*

**Interpretation:** race stays broadly similar between full and sampled populations in both groups (within ~5-6 points per category). Ethnicity is nearly identical for the treatment group (12.2% Hispanic/Latino in both) but shows a real gap for baseline (19.8% sampled vs. 14.1% full — a 5.7-point overrepresentation). Gender shows the most drift: the treatment subset skews more female than its full cohort (54.1% vs. 47.9%), while the baseline subset skews more male than its full pool (57.3% vs. 49.5%). This is most plausibly attributable to which patients happened to have a Progress Note within the 7-day extraction window, rather than bias in the random sampling step itself (baseline patients were drawn via a deterministic random sample before any note-availability filtering was applied).

---

## Part 2: Unstructured Data Extraction (Milestone 2)

To validate the structured cohort definitions, clinical notes for the 268-patient sampled subset (771 total notes: 396 treatment, 375 baseline) were analyzed. Concepts were extracted using a standard regex pattern-match alongside three distinct LLMs (Qwen2.5-7B-Instruct, Llama-3-OpenBioLLM-8B, Mistral-7B-Instruct), each run with structured/guided decoding to enforce strict binary YES/NO classification.

*All patient-level counts below (n=268) were regenerated from `table1_generator.py` after adding ethnicity to the per-patient rollup and Table 1 output, which was missing from the original version of the script.*

### A. DIAGNOSIS (Diverticulitis) Demographics

**Table 1.1: Diagnosis via Pattern-Match Baseline (Athena)**

| Demographic Characteristic | Diverticulitis: NO (n=41) | Diverticulitis: YES (n=227) |
|---|---:|---:|
| Age (Mean ± SD) | 60.63 ± 12.38 | 59.76 ± 13.67 |
| **Gender** | | |
| Female | 18 (43.9%) | 116 (51.1%) |
| Male | 23 (56.1%) | 111 (48.9%) |
| **Race** | | |
| White | 23 (56.1%) | 143 (63.0%) |
| Asian | 9 (22.0%) | 28 (12.3%) |
| Black or African American | 2 (4.9%) | 14 (6.2%) |
| Declined / Unknown / Pac. Isl. | 1 (2.4%) | 3 (1.2%) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 37 (90.2%) | 185 (81.5%) |
| Hispanic or Latino | 3 (7.3%) | 37 (16.3%) |
| Declined | 1 (2.4%) | 4 (1.8%) |
| Unknown | 0 (0.0%) | 1 (0.4%) |

**Table 1.2: Diagnosis via Llama-3-OpenBioLLM**

| Demographic Characteristic | Diverticulitis: NO (n=22) | Diverticulitis: YES (n=246) |
|---|---:|---:|
| Age (Mean ± SD) | 57.82 ± 13.63 | 60.08 ± 13.46 |
| **Gender** | | |
| Female | 12 (54.5%) | 122 (49.6%) |
| Male | 10 (45.5%) | 124 (50.4%) |
| **Race** | | |
| White | 15 (68.2%) | 151 (61.4%) |
| Asian | 4 (18.2%) | 33 (13.4%) |
| Black or African American | 1 (4.5%) | 15 (6.1%) |
| Declined / Unknown / Pac. Isl. | 1 (4.5%) | 3 (1.2%) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 18 (81.8%) | 204 (82.9%) |
| Hispanic or Latino | 3 (13.6%) | 37 (15.0%) |
| Declined | 1 (4.5%) | 4 (1.6%) |
| Unknown | 0 (0.0%) | 1 (0.4%) |

**Table 1.3: Diagnosis via Qwen**

| Demographic Characteristic | Diverticulitis: NO (n=64) | Diverticulitis: YES (n=204) |
|---|---:|---:|
| Age (Mean ± SD) | 60.44 ± 11.65 | 59.72 ± 14.01 |
| **Gender** | | |
| Female | 24 (37.5%) | 110 (53.9%) |
| Male | 40 (62.5%) | 94 (46.1%) |
| **Race** | | |
| White | 39 (60.9%) | 127 (62.3%) |
| Asian | 9 (14.1%) | 28 (13.7%) |
| Black or African American | 4 (6.2%) | 12 (5.9%) |
| Declined / Unknown / Pac. Isl. | 1 (1.6%) | 3 (1.5%) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 56 (87.5%) | 166 (81.4%) |
| Hispanic or Latino | 6 (9.4%) | 34 (16.7%) |
| Declined | 1 (1.6%) | 4 (2.0%) |
| Unknown | 1 (1.6%) | 0 (0.0%) |

**Table 1.4: Diagnosis via Mistral**

| Demographic Characteristic | Diverticulitis: NO (n=30) | Diverticulitis: YES (n=238) |
|---|---:|---:|
| Age (Mean ± SD) | 60.20 ± 11.37 | 59.85 ± 13.73 |
| **Gender** | | |
| Female | 13 (43.3%) | 121 (50.8%) |
| Male | 17 (56.7%) | 117 (49.2%) |
| **Race** | | |
| White | 19 (63.3%) | 147 (61.8%) |
| Asian | 5 (16.7%) | 32 (13.4%) |
| Black or African American | 2 (6.7%) | 14 (5.9%) |
| Declined / Unknown / Pac. Isl. | 1 (3.3%) | 2 (0.8%) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 25 (83.3%) | 197 (82.8%) |
| Hispanic or Latino | 5 (16.7%) | 35 (14.7%) |
| Declined | 0 (0.0%) | 5 (2.1%) |
| Unknown | 0 (0.0%) | 1 (0.4%) |

### B. DRUG (Amoxicillin-Clavulanate) Demographics

**Table 2.1: Drug via Pattern-Match Baseline**

| Demographic Characteristic | Drug: NO (n=135) | Drug: YES (n=133) |
|---|---:|---:|
| Age (Mean ± SD) | 60.49 ± 12.30 | 59.29 ± 14.58 |
| **Gender** | | |
| Female | 61 (45.2%) | 73 (54.9%) |
| Male | 74 (54.8%) | 60 (45.1%) |
| **Race** | | |
| White | 85 (63.0%) | 81 (60.9%) |
| Asian | 14 (10.4%) | 23 (17.3%) |
| Black or African American | 7 (5.2%) | 9 (6.8%) |
| Declined / Unknown / Pac. Isl. | 2 (1.4%) | 2 (1.6%) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 109 (80.7%) | 113 (85.0%) |
| Hispanic or Latino | 24 (17.8%) | 16 (12.0%) |
| Declined | 2 (1.5%) | 3 (2.3%) |
| Unknown | 0 (0.0%) | 1 (0.8%) |

**Table 2.2: Drug via Llama-3-OpenBioLLM**

| Demographic Characteristic | Drug: NO (n=21) | Drug: YES (n=247) |
|---|---:|---:|
| Age (Mean ± SD) | 54.67 ± 12.59 | 60.34 ± 13.47 |
| **Gender** | | |
| Female | 11 (52.4%) | 123 (49.8%) |
| Male | 10 (47.6%) | 124 (50.2%) |
| **Race** | | |
| White | 9 (42.9%) | 157 (63.6%) |
| Asian | 3 (14.3%) | 34 (13.8%) |
| Black or African American | 2 (9.5%) | 14 (5.7%) |
| Declined / Unknown / Pac. Isl. | 1 (4.8%) | 3 (1.2%) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 14 (66.7%) | 208 (84.2%) |
| Hispanic or Latino | 6 (28.6%) | 34 (13.8%) |
| Declined | 1 (4.8%) | 4 (1.6%) |
| Unknown | 0 (0.0%) | 1 (0.4%) |

**Table 2.3: Drug via Qwen**

| Demographic Characteristic | Drug: NO (n=163) | Drug: YES (n=105) |
|---|---:|---:|
| Age (Mean ± SD) | 60.85 ± 12.48 | 58.41 ± 14.81 |
| **Gender** | | |
| Female | 78 (47.9%) | 56 (53.3%) |
| Male | 85 (52.1%) | 49 (46.7%) |
| **Race** | | |
| White | 100 (61.3%) | 66 (62.9%) |
| Asian | 20 (12.3%) | 17 (16.2%) |
| Black or African American | 9 (5.5%) | 7 (6.7%) |
| Declined / Unknown / Pac. Isl. | 3 (1.8%) | 1 (1.0%) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 128 (78.5%) | 94 (89.5%) |
| Hispanic or Latino | 31 (19.0%) | 9 (8.6%) |
| Declined | 3 (1.8%) | 2 (1.9%) |
| Unknown | 1 (0.6%) | 0 (0.0%) |

**Table 2.4: Drug via Mistral**

| Demographic Characteristic | Drug: NO (n=108) | Drug: YES (n=160) |
|---|---:|---:|
| Age (Mean ± SD) | 59.14 ± 12.78 | 60.40 ± 13.93 |
| **Gender** | | |
| Female | 47 (43.5%) | 87 (54.4%) |
| Male | 61 (56.5%) | 73 (45.6%) |
| **Race** | | |
| White | 72 (66.7%) | 94 (58.8%) |
| Asian | 11 (10.2%) | 26 (16.2%) |
| Black or African American | 2 (1.9%) | 14 (8.8%) |
| Declined / Unknown / Pac. Isl. | 2 (1.8%) | 2 (1.2%) |
| **Ethnicity** | | |
| Not Hispanic or Latino | 84 (77.8%) | 138 (86.2%) |
| Hispanic or Latino | 20 (18.5%) | 20 (12.5%) |
| Declined | 3 (2.8%) | 2 (1.2%) |
| Unknown | 1 (0.9%) | 0 (0.0%) |

---

## Reliability Analysis (Structured vs. Unstructured Data)

Based on the results of this analysis, structured EHR data was more reliable and reproducible for defining cohort inclusion/exclusion criteria than extracting concepts from unstructured clinical notes via LLMs.

This conclusion follows from cross-referencing unstructured drug extractions against the structured cohort assignment (which group a patient belonged to, based on formalized EHR billing/prescription data):

**1. Systematic over-prediction (OpenBioLLM).** Even with structured/guided decoding enforcing a strict YES/NO output, OpenBioLLM substantially over-predicted positive drug mentions. Of the 96 sampled baseline patients (who by definition never received the drug), the pattern-match baseline found only 10 positive mentions (likely historical allergy notes or negated phrasing). OpenBioLLM flagged 89 of these same 96 patients as positive. An earlier, less-constrained run of this model produced free-text responses that made the failure mode directly visible — including "YES" answers on notes with no drug-related content at all (e.g., a neurosurgery post-op check, an orthopedic physical therapy note); the bias persisted even after switching to guided decoding, indicating a genuine calibration issue with this model on this task rather than an output-formatting artifact.

**2. Over-conservatism vs. false positives (Qwen & Mistral).** Qwen showed strong specificity (89/96 baseline patients correctly identified as true negatives) but was overly conservative, producing 74 false negatives among the 172 confirmed-treated patients. Mistral achieved better sensitivity (123/172 true positives) but hallucinated 37 false positives among the 96 baseline patients.

**3. Concordance: Drug Mentions by Cohort Group**

| Extraction Method | NO Drug — Baseline Group (n=96) | YES Drug — Treatment Group (n=172) |
|---|---|---|
| Pattern-Match | 86 True Negatives (10 False Positives) | 123 True Positives (49 False Negatives) |
| OpenBioLLM | 7 True Negatives (89 False Positives) | 158 True Positives (14 False Negatives) |
| Qwen | 89 True Negatives (7 False Positives) | 98 True Positives (74 False Negatives) |
| Mistral | 59 True Negatives (37 False Positives) | 123 True Positives (49 False Negatives) |

I have not calculated any scoring metrics. This is because, considering EHR as ground truth labels in order to calculate them, is incorrect in my opinion in my opinion. We can use the massive cross-model instability as a reason for why EHR is better, but we cannot consider it a ground truth. 


**Conclusion:** There are two lines of evidence that support relying on structured EHR data over LLM-based note extraction for identifying drug administration in this cohort. First, the three LLMs contrasted each other on identical note text. OpenBioLLM flagged 91% of notes as drug-positive, Qwen only 32%, and Mistral 60%. This indicates the extraction method itself isn't a stable, reproducible signal independent of which model is used. After manual review of some specific cases, I came to the conclusion that this was not just different judgment in decision. OpenBioLLM classified notes with no drug-related content at all (a neurosurgery post-operative check, a physical therapy note) as positive, which is a direct verifiable error. Second, when compared against structured medication exposure data, all three models showed substantial disagreement in one direction or the other. This second comparison treats structured data as a reference point rather than a verified gold standard, since drug exposure records could themselves contain entry errors, but, as the most direct record of a clinical event, it remains the more reliable evidence for this analysis. Taken together, the cross-model inconsistency on identical text, directly observed hallucination, and disagreement with the most proximate available record of drug administration, we can conclude structured EHR data is currently the more reliable source for defining strict cohort inclusion criteria, while acknowledging that a fully independent validation would require blinded manual chart review beyond this analysis's scope.
