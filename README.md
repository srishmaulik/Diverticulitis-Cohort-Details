**Srish Maulik** 
**AD206**

**A retrospective cohort study on the effect of amoxicillin/clavulanate for diverticulitis of the colon**

**1. Purpose of the Study**

This study evaluates the effectiveness of amoxicillin/clavulanate in treating diverticulitis of the colon as compared to patients who did not receive this regimen within 14 days of diagnosis. This drug is commonly prescribed as first-line oral antibiotic therapy for uncomplicated diverticulitis.
Using Atlas, I proved that a retrospective cohort for this drug-outcome pair can be constructed and analyzed using UCSF's de-identified research data assets.
Outcome measure (treatment failure): a composite flag capturing evidence of clinical deterioration in the 30 days following the index diagnosis, or for patients being treated, after the first drug exposure, including:
- IR drainage procedures (abscess drainage, percutaneous tube placement/change)
- A diagnosis of perforation, abscess, or fistula on a subsequent encounter
- Emergency department presentation
- Acute-visit-type encounters
- Operative episodes (surgery/anesthesia encounters specifically tied to a surgical department)



**2. Cohort Definition — Qualification Cohort**

Inclusion criteria:
- Diagnosis of diverticulitis of the colon (OMOP concept 77025 and descendants), first qualifying episode per patient
- Age ≥ 18 at diagnosis
- Diagnosis date falls within an active observation period.
  
This qualification cohort, including all patients who met the requirement of having the diverticulitis diagnosis and were adults of the ages 18 or above, were included in this cohort. Here is the Table1 for this qualification cohort. 

| Demographic Characteristic | Qualification Cohort (n=1,946) |
|----------------------------|-------------------------------:|
| **Gender** | |
| Female | 974 (50.1%) |
| Male | 971 (49.9%) |
| **Race** | |
| White | 1,289 (66.2%) |
| Other Races | 275 (14.1%) |
| Asian | 158 (8.1%) |
| Black or African American | 106 (5.4%) |
| Unknown Race | 87 (4.5%) |
| Native Hawaiian / Pacific Islander | 17 (0.9%) |
| **Ethnicity** | |
| Not Hispanic or Latino | 1,536 (78.9%) |
| Hispanic or Latino | 269 (13.8%) |
| Unknown Ethnicity | 141 (7.2%) |


<img width="819" height="457" alt="Screenshot 2026-08-04 at 4 13 37 PM" src="https://github.com/user-attachments/assets/9047807f-3479-41d4-a184-1f0014699708" />


**3. Cohort Definition — Treatment Cohort**

Of the 1,946 qualifying patients, those who additionally received amoxicillin/clavulanate (OMOP drug concepts 40105044, 40131073, 40131077, 40105046 and descendants) within 14 days of diagnosis were assigned to the treatment cohort: n = 311 patients, with a follow up window of 30 days. 

Table 1 — Qualification Cohort vs. Treatment Cohort

This Table 1 compares the  full qualifying population (n=1,946, which includes the 311 treated patients) compared against the subset who received amoxicillin/clavulanate (n=311).

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

I have also created a Table 1 to show the comparison between those who didn't take the drug within 14 days(our control) and those who received amoxicillin/clavulanate (OMOP drug concepts 40105044, 40131073, 40131077, 40105046 and descendants) within 14 days of diagnosis were assigned to the treatment cohort: n = 311 patients.


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

As seen in the tables and images, the demographics were broadly similar, with a slight over-representation of the Asian community in the treatment cohort and suppressed records of unrepresented/unknown races or native Hawaiins and Pacific Islanders. 


<img width="821" height="459" alt="Screenshot 2026-08-04 at 4 11 47 PM" src="https://github.com/user-attachments/assets/eeee6482-3a84-43b3-83e2-d46a80e74856" />


**4. Outcome Analysis**

The 30-day treatment-failure window was anchored to the diagnosis date for the baseline cohort (no amoxicillin/clavulanate drug exposure to refer to), and to the drug start date for the treatment cohort to avoid protopathic bias, which is attributing pre-treatment clinical events to the drug. 
To measure the effectiveness of the amoxicillin/clavulanate drug, I conducted a measuring of the failure rates of the drug. 
To determine what would be a failure of the drug, I have already listed the criteria in the first section, where I mentioned the Study's Purpose. Below is the table showing the difference in failure rates. 

| Cohort | n | Treatment Failures | Failure Rate |
|--------|--:|-------------------:|-------------:|
| Treatment (amoxicillin/clavulanate) | 311 | 51 | 16.4% |
| Baseline (no amox/clav within 14 days) | 1,635 | 124 | 7.6% |



| Cohort | Failure | Success | Row Total |
|--------|--------:|--------:|----------:|
| Treatment | 51 | 260 | 311 |
| Baseline | 124 | 1,511 | 1,635 |
| **Column Total** | **175** | **1,771** | **1,946** |


Statistical comparison:

Absolute difference: 8.8 percentage points

Relative risk: 2.16x

To check whether the treatment status has an association to the failure rate, I conducted a chi-square test, with my null hypothesis stating that there is no relationship between the treatment status and the failure rate observed. For our table, we get a df(degrees of freedom) = 1 and a χ² = 24.81. On evaluation of the chi-square distribution, the p value is calculated as 6.3×10⁻⁷. Hence the null hypothesis is rejected, and the p value indicates that a relationship does exist between the failure rate and the treatment status. 



**5. Statistical Power Analysis**

   
Given the observed effect size (Cohen's h = 0.34) and sample sizes (n1=311, n2=1,635), the achieved statistical power at α=0.05 exceeds 99%. The minimum treatment sample size required for conventional 80% power at this size and allocation ratio is approximately 83 patients, which is below the 311 patients available. Sample size is not a limiting factor in this analysis.

**6. Limitations**


- Confounding by Indication (The "Sicker Patient" Bias) : In a cohort study, doctors do not randomize who gets what. If patients who took amoxicillin/clavulanate had a higher failure rate than those who took nothing or something that was not a powerful broad spectrum antibiotic like what amoxicillin/clavulanate is, it is highly likely because the group that didn't take the drug had a much milder disease to begin with. Modern medical guidelines (such as those from the American Gastroenterological Association) even  recommend a no-antibiotic watchful waiting approach for very mild, completely uncomplicated diverticulitis, as these patients usually recover on their own. So if a doctor did prescribe amoxicillin/clavulanate, that patient likely had elevated markers like inflammation, more pain, meaning that they were already at a higher baseline risk for treatment failure or hospitalization. 
- Comparator composition: The baseline cohort excludes only patients who received amoxicillin/clavulanate within 14 days of diagnosis. It does not exclude patients who received an alternate antibiotic regimen (e.g metronidazole, fluoroquinolones). The baseline is therefore best described as "did not receive this specific drug early," not as a pure untreated comparator.


code - https://github.com/srishmaulik/Diverticulitis-Cohort-Details



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



Extraction Method	Baseline FP	Treatment FN
Pattern-Match	10	49
OpenBioLLM	89	14
Qwen	7	74
Mistral	37	49
