# Milestone 2: Cohort Validity and Clinical Note Analysis

## Part 1: Structured Cohort Demographics (From Milestone 1)

**1. Cohort Definition — Qualification Cohort vs. Treatment Cohort**
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

**2. Cohort Definition — Baseline Cohort vs. Treatment Cohort**
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

---

## Part 2: Unstructured Data Extraction (Milestone 2)

To validate the structured cohort definitions, clinical notes for a sampled subset of 268 unique patients (accounting for 771 total clinical notes) were analyzed. Of the 771 notes extracted, 396 belonged to patients in the true treatment cohort, and 375 belonged to the baseline cohort.

Concepts were extracted using a standard Regex Pattern-Match alongside three distinct LLMs (Qwen, Llama-3-OpenBioLLM, Mistral) utilizing structured decoding for strict binary classification.

### A. DIAGNOSIS (Diverticulitis) Demographics

**Table 1.1: Diagnosis via Pattern-Match Baseline(Athena)**
| Demographic Characteristic | Diverticulitis: NO (n=41) | Diverticulitis: YES (n=227) |
|----------------------------|--------------------------:|-------------------------:|
| **Age (Mean ± SD)** | 60.63 ± 12.38 | 59.76 ± 13.67 |
| **Gender** | | |
| Female | 18 (43.9%) | 116 (51.1%) |
| Male | 23 (56.1%) | 111 (48.9%) |
| **Race** | | |
| White | 23 (56.1%) | 143 (63.0%) |
| Asian | 9 (22.0%) | 28 (12.3%) |
| Black or African American | 2 (4.9%) | 14 (6.2%) |
| Declined / Unknown / Pac. Isl. | 1 (2.4%) | 3 (1.2%) |

**Table 1.2: Diagnosis via Llama-3-OpenBioLLM**
| Demographic Characteristic | Diverticulitis: NO (n=22) | Diverticulitis: YES (n=246) |
|----------------------------|--------------------------:|-------------------------:|
| **Age (Mean ± SD)** | 57.82 ± 13.63 | 60.08 ± 13.46 |
| **Gender** | | |
| Female | 12 (54.5%) | 122 (49.6%) |
| Male | 10 (45.5%) | 124 (50.4%) |
| **Race** | | |
| White | 15 (68.2%) | 151 (61.4%) |
| Asian | 4 (18.2%) | 33 (13.4%) |
| Black or African American | 1 (4.5%) | 15 (6.1%) |
| Declined / Unknown / Pac. Isl. | 1 (4.5%) | 3 (1.2%) |

**Table 1.3: Diagnosis via Qwen**
| Demographic Characteristic | Diverticulitis: NO (n=64) | Diverticulitis: YES (n=204) |
|----------------------------|--------------------------:|-------------------------:|
| **Age (Mean ± SD)** | 60.44 ± 11.65 | 59.72 ± 14.01 |
| **Gender** | | |
| Female | 24 (37.5%) | 110 (53.9%) |
| Male | 40 (62.5%) | 94 (46.1%) |
| **Race** | | |
| White | 39 (60.9%) | 127 (62.3%) |
| Asian | 9 (14.1%) | 28 (13.7%) |
| Black or African American | 4 (6.2%) | 12 (5.9%) |
| Declined / Unknown / Pac. Isl. | 1 (1.6%) | 3 (1.5%) |

**Table 1.4: Diagnosis via Mistral**
| Demographic Characteristic | Diverticulitis: NO (n=30) | Diverticulitis: YES (n=238) |
|----------------------------|--------------------------:|-------------------------:|
| **Age (Mean ± SD)** | 60.20 ± 11.37 | 59.85 ± 13.73 |
| **Gender** | | |
| Female | 13 (43.3%) | 121 (50.8%) |
| Male | 17 (56.7%) | 117 (49.2%) |
| **Race** | | |
| White | 19 (63.3%) | 147 (61.8%) |
| Asian | 5 (16.7%) | 32 (13.4%) |
| Black or African American | 2 (6.7%) | 14 (5.9%) |
| Declined / Unknown / Pac. Isl. | 1 (3.3%) | 2 (0.8%) |

---

### B. DRUG (Amoxicillin-Clavulanate) Demographics

**Table 2.1: Drug via Pattern-Match Baseline**
| Demographic Characteristic | Drug: NO (n=135) | Drug: YES (n=133) |
|----------------------------|--------------------------:|-------------------------:|
| **Age (Mean ± SD)** | 60.49 ± 12.30 | 59.29 ± 14.58 |
| **Gender** | | |
| Female | 61 (45.2%) | 73 (54.9%) |
| Male | 74 (54.8%) | 60 (45.1%) |
| **Race** | | |
| White | 85 (63.0%) | 81 (60.9%) |
| Asian | 14 (10.4%) | 23 (17.3%) |
| Black or African American | 7 (5.2%) | 9 (6.8%) |
| Declined / Unknown / Pac. Isl. | 2 (1.4%) | 2 (1.6%) |

**Table 2.2: Drug via Llama-3-OpenBioLLM**
| Demographic Characteristic | Drug: NO (n=21) | Drug: YES (n=247) |
|----------------------------|--------------------------:|-------------------------:|
| **Age (Mean ± SD)** | 54.67 ± 12.59 | 60.34 ± 13.47 |
| **Gender** | | |
| Female | 11 (52.4%) | 123 (49.8%) |
| Male | 10 (47.6%) | 124 (50.2%) |
| **Race** | | |
| White | 9 (42.9%) | 157 (63.6%) |
| Asian | 3 (14.3%) | 34 (13.8%) |
| Black or African American | 2 (9.5%) | 14 (5.7%) |
| Declined / Unknown / Pac. Isl. | 1 (4.8%) | 3 (1.2%) |

**Table 2.3: Drug via Qwen**
| Demographic Characteristic | Drug: NO (n=163) | Drug: YES (n=105) |
|----------------------------|--------------------------:|-------------------------:|
| **Age (Mean ± SD)** | 60.85 ± 12.48 | 58.41 ± 14.81 |
| **Gender** | | |
| Female | 78 (47.9%) | 56 (53.3%) |
| Male | 85 (52.1%) | 49 (46.7%) |
| **Race** | | |
| White | 100 (61.3%) | 66 (62.9%) |
| Asian | 20 (12.3%) | 17 (16.2%) |
| Black or African American | 9 (5.5%) | 7 (6.7%) |
| Declined / Unknown / Pac. Isl. | 3 (1.8%) | 1 (1.0%) |

**Table 2.4: Drug via Mistral**
| Demographic Characteristic | Drug: NO (n=108) | Drug: YES (n=160) |
|----------------------------|--------------------------:|-------------------------:|
| **Age (Mean ± SD)** | 59.14 ± 12.78 | 60.40 ± 13.93 |
| **Gender** | | |
| Female | 47 (43.5%) | 87 (54.4%) |
| Male | 61 (56.5%) | 73 (45.6%) |
| **Race** | | |
| White | 72 (66.7%) | 94 (58.8%) |
| Asian | 11 (10.2%) | 26 (16.2%) |
| Black or African American | 2 (1.9%) | 14 (8.8%) |
| Declined / Unknown / Pac. Isl. | 2 (1.8%) | 2 (1.2%) |

---

## Reliability Analysis (Structured vs. Unstructured Data)

Based on the results of this analysis, **structured EHR data** was more reliable and easily reproducible for defining cohort inclusion/exclusion criteria than extracting concepts from unstructured clinical notes via LLMs. 

I cam to this conclusion after a cross-reference of the unstructured drug extractions against the structured cohort definitions (which groups a patient belonged to based on formalized EHR billing/prescription data):

**1. The "Always Yes" Hallucination (OpenBioLLM)**
Despite using structured decoding to enforce binary outputs, the domain-specific OpenBioLLM massively over-predicted positive cases. Of the 771 notes pulled, 375 belonged to the baseline cohort (patients who definitively *did not* receive the drug). The Regex baseline found only 10 positive mentions in this group (likely historical allergies or negated sentences). In contrast, OpenBioLLM flagged 89 of these baseline patients as actively taking the drug. Manual review confirmed severe hallucinations, with the model returning "YES" for antibiotic mentions on entirely unrelated notes (e.g., neurosurgery post-op and orthopedic physical therapy). 

**2. Over-Conservatism vs. False Positives (Qwen & Mistral)**
While Qwen demonstrated excellent specificity (correctly identifying 89 baseline cases as true negatives), it was overly conservative, resulting in 74 false negatives among the true treatment group. Mistral achieved better sensitivity (123 true positives) but still hallucinated 37 positive cases in the baseline group.

**3. Concordance: Drug Mentions by Cohort Group**
| Extraction Method | NO Drug (Baseline Group) | YES Drug (Treatment Group) |
| :--- | :--- | :--- |
| **Structured/Pattern-Match** | 86 True Negatives | 123 True Positives |
| **OpenBioLLM** | 7 True Negatives *(89 False Positives)* | 158 Positives |
| **Qwen** | 89 True Negatives | 98 True Positives *(74 False Negatives)*|
| **Mistral** | 59 True Negatives *(37 False Positives)* | 123 True Positives |

**Conclusion:** 
While clinical notes contain rich, nuanced data, extracting drug exposures via zero-shot LLM inference introduces unacceptable levels of variance, hallucination, and sensitivity to prompt architecture. Unless an LLM pipeline is rigorously fine-tuned and verified for high specificity (like Qwen, though at the cost of sensitivity), relying on structured medication exposure tables (Milestone 1) is a far more robust mechanism for defining strict cohort criteria.
