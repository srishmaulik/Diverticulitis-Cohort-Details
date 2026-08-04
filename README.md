Srish Maulik AD206

Retrospective Cohort Study: Amoxicillin/Clavulanate for Diverticulitis of the Colon

1. Purpose of the Study
This study evaluates the effectiveness of amoxicillin/clavulanate in treating diverticulitis of the colon as compared to other treatments. This drug is commonly prescribed as first-line oral antibiotic therapy for uncomplicated diverticulitis.
Using Atlas, I proved that a retrospective cohort for this drug-outcome pair can be constructed and analyzed using UCSF's de-identified research data assets.
Outcome measure (treatment failure): a composite flag capturing evidence of clinical deterioration in the 30 days following the index diagnosis, or for patients being treated, after the first drug exposure, including:
- IR drainage procedures (abscess drainage, percutaneous tube placement/change)
- A diagnosis of perforation, abscess, or fistula on a subsequent encounter
- Emergency department presentation
- Acute-visit-type encounters
- Operative episodes (surgery/anesthesia encounters specifically tied to a surgical department)


2. Cohort Definition — Qualification Cohort
Inclusion criteria:
- Diagnosis of diverticulitis of the colon (OMOP concept 77025 and descendants), first qualifying episode per patient
- Age ≥ 18 at diagnosis
- Diagnosis date falls within an active observation period.
  
This qualification cohort, including all patients who met the requirement of having the diverticulitis diagnosis and were adults of the ages 18 or above, were included in this cohort. Here is the Table1 for this qualification cohort. 

<img width="469" height="642" alt="Screenshot 2026-08-04 at 11 35 10 AM" src="https://github.com/user-attachments/assets/d4693e09-f3b2-45d4-92a4-bd5059d1a147" />

<img width="819" height="457" alt="Screenshot 2026-08-04 at 4 13 37 PM" src="https://github.com/user-attachments/assets/9047807f-3479-41d4-a184-1f0014699708" />


3. Cohort Definition — Treatment Cohort
Of the 1,946 qualifying patients, those who additionally received amoxicillin/clavulanate (OMOP drug concepts 40105044, 40131073, 40131077, 40105046 and descendants) within 14 days of diagnosis were assigned to the treatment cohort: n = 311 patients, with a follow up window of 30 days. 

Table 1 — Qualification Cohort vs. Treatment Cohort

This Table 1 compares the  full qualifying population (n=1,946, which includes the 311 treated patients) compared against the subset who received amoxicillin/clavulanate (n=311).

<img width="550" height="645" alt="Screenshot 2026-08-04 at 12 07 12 PM" src="https://github.com/user-attachments/assets/14242e3c-677e-4f07-83e9-3ce55d6e1df0" />


I have also created a Table 1 to show the comparison between those who didn't take the drug within 14 days(our control) and those who received amoxicillin/clavulanate (OMOP drug concepts 40105044, 40131073, 40131077, 40105046 and descendants) within 14 days of diagnosis were assigned to the treatment cohort: n = 311 patients.


<img width="572" height="565" alt="Screenshot 2026-08-04 at 11 42 55 AM" src="https://github.com/user-attachments/assets/d2c462a8-c0d3-4029-be63-e078a15d2de3" />

As seen in the tables and images, the demographics were broadly similar, with a slight over-representation of the Asian community in the treatment cohort and suppressed records of unrepresented/unknown races or native Hawaiins and Pacific Islanders. 

<img width="821" height="459" alt="Screenshot 2026-08-04 at 4 11 47 PM" src="https://github.com/user-attachments/assets/eeee6482-3a84-43b3-83e2-d46a80e74856" />


4. Outcome Analysis

The 30-day treatment-failure window was anchored to the diagnosis date for the baseline cohort (no amoxicillin/clavulanate drug exposure to refer to), and to the drug start date for the treatment cohort to avoid protopathic bias, which is attributing pre-treatment clinical events to the drug. 
To measure the effectiveness of the amoxicillin/clavulanate drug, I conducted a measuring of the failure rates of the drug. 
To determine what would be a failure of the drug, I have already listed the criteria in the first section, where I mentioned the Study's Purpose. Below is the table showing the difference in failure rates. 

<img width="452" height="191" alt="Screenshot 2026-08-04 at 11 49 27 AM" src="https://github.com/user-attachments/assets/c9a7cc82-cc0b-4a93-9673-c349d783593e" />


<img width="635" height="162" alt="Screenshot 2026-08-04 at 1 35 52 PM" src="https://github.com/user-attachments/assets/dc9540d6-da1f-490e-9c53-349e73992c19" />

Statistical comparison:

Absolute difference: 8.8 percentage points

Relative risk: 2.16x

To check whether the treatment status has an association to the failure rate, I conducted a chi-square test, with my null hypothesis stating that there is no relationship between the treatment status and the failure rate observed. For our table, we get a df(degrees of freedom) = 1 and a χ² = 24.81. On evaluation of the chi-square distribution, the p value is calculated as 6.3×10⁻⁷. Hence the null hypothesis is rejected, and the p value indicates that a relationship does exist between the failure rate and the treatment status. 



5. Statistical Power Analysis
   
Given the observed effect size (Cohen's h = 0.34) and sample sizes (n1=311, n2=1,635), the achieved statistical power at α=0.05 exceeds 99%. The minimum treatment sample size required for conventional 80% power at this size and allocation ratio is approximately 83 patients, which is below the 311 patients available. Sample size is not a limiting factor in this analysis.

6. Limitations

- Confounding by Indication (The "Sicker Patient" Bias) : In a cohort study, doctors do not randomize who gets what. If patients who took amoxicillin/clavulanate had a higher failure rate than those who took nothing or something that was not a powerful broad spectrum antibiotic like what amoxicillin/clavulanate is, it is highly likely because the group that didn't take the drug had a much milder disease to begin with. Modern medical guidelines (such as those from the American Gastroenterological Association) even  recommend a no-antibiotic watchful waiting approach for very mild, completely uncomplicated diverticulitis, as these patients usually recover on their own. So if a doctor did prescribe amoxicillin/clavulanate, that patient likely had elevated markers like inflammation, more pain, meaning that they were already at a higher baseline risk for treatment failure or hospitalization. 
- Comparator composition: The baseline cohort excludes only patients who received amoxicillin/clavulanate within 14 days of diagnosis. It does not exclude patients who received an alternate antibiotic regimen (e.g metronidazole, fluoroquinolones). The baseline is therefore best described as "did not receive this specific drug early," not as a pure untreated comparator.
