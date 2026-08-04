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
