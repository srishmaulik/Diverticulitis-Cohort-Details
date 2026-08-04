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
         row_number() over (partition by pe.person_id order by pe.start_date ASC) as ordinal, 
         cast(pe.visit_occurrence_id as bigint) as visit_occurrence_id
  FROM (
    SELECT P.ordinal as event_id, P.person_id, P.start_date, P.end_date, op_start_date, op_end_date, 
           cast(P.visit_occurrence_id as bigint) as visit_occurrence_id
    FROM (
      SELECT E.person_id, E.start_date, E.end_date,
             row_number() OVER (PARTITION BY E.person_id ORDER BY E.sort_date ASC, E.event_id) ordinal,
             OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date, 
             cast(E.visit_occurrence_id as bigint) as visit_occurrence_id
      FROM (
        SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
               C.visit_occurrence_id, C.start_date as sort_date
        FROM (
          SELECT co.person_id, co.condition_occurrence_id, co.condition_concept_id, co.visit_occurrence_id,
                 co.condition_start_date as start_date, 
                 COALESCE(co.condition_end_date, date_add('day', 1, co.condition_start_date)) as end_date 
          FROM deid_omop.condition_occurrence co
          JOIN Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 0)
        ) C
      ) E
      JOIN deid_omop.observation_period OP on E.person_id = OP.person_id 
           AND E.start_date >= OP.observation_period_start_date 
           AND E.start_date <= op.observation_period_end_date
      WHERE OP.observation_period_start_date <= E.start_date 
        AND E.start_date <= OP.observation_period_end_date
    ) P
    WHERE P.ordinal = 1
  ) pe
),

Inclusion_0 AS (
  SELECT 0 as inclusion_rule_id, pe.person_id, pe.event_id
  FROM qualified_events pe
  JOIN (
    SELECT 0 as index_id, person_id, event_id
    FROM (
      SELECT E.person_id, E.event_id 
      FROM qualified_events E
      INNER JOIN (
        SELECT 0 as index_id, e.person_id, e.event_id
        FROM qualified_events E
        JOIN deid_omop.person P ON P.person_id = E.person_id
        WHERE year(E.start_date) - P.year_of_birth >= 18
        GROUP BY e.person_id, e.event_id
      ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
      GROUP BY E.person_id, E.event_id
      HAVING COUNT(index_id) = 1
    ) G
  ) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
),

Inclusion_1 AS (
  SELECT 1 as inclusion_rule_id, pe.person_id, pe.event_id
  FROM qualified_events pe
  JOIN (
    SELECT 0 as index_id, person_id, event_id
    FROM (
      SELECT E.person_id, E.event_id 
      FROM qualified_events E
      INNER JOIN (
        SELECT 0 as index_id, cc.person_id, cc.event_id
        FROM (
          SELECT p.person_id, p.event_id 
          FROM qualified_events P
          JOIN (
            SELECT C.person_id, C.drug_exposure_id as event_id, C.start_date, C.end_date,
                   C.visit_occurrence_id, C.start_date as sort_date
            FROM (
              SELECT de.person_id, de.drug_exposure_id, de.drug_concept_id, de.visit_occurrence_id,
                     days_supply, quantity, refills, de.drug_exposure_start_date as start_date, 
                     COALESCE(de.drug_exposure_end_date, 
                              date_add('day', de.days_supply, de.drug_exposure_start_date), 
                              date_add('day', 1, de.drug_exposure_start_date)) as end_date 
              FROM deid_omop.drug_exposure de
              JOIN Codesets cs on (de.drug_concept_id = cs.concept_id and cs.codeset_id = 1)
            ) C
          ) A on A.person_id = P.person_id  
             AND A.start_date >= P.op_start_date 
             AND A.start_date <= P.op_end_date 
             AND A.start_date >= P.start_date 
             AND A.start_date <= date_add('day', 14, P.start_date) 
        ) cc 
        GROUP BY cc.person_id, cc.event_id
        HAVING COUNT(cc.event_id) >= 1
      ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
      GROUP BY E.person_id, E.event_id
      HAVING COUNT(index_id) = 1
    ) G
  ) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
),

inclusion_events AS (
  SELECT inclusion_rule_id, person_id, event_id FROM Inclusion_0
  UNION ALL
  SELECT inclusion_rule_id, person_id, event_id FROM Inclusion_1
),

included_events AS (
  SELECT event_id, person_id, start_date, end_date, op_start_date, op_end_date
  FROM (
    SELECT event_id, person_id, start_date, end_date, op_start_date, op_end_date, 
           row_number() over (partition by person_id order by start_date ASC) as ordinal
    FROM (
      SELECT Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date, 
             SUM(coalesce(cast(pow(2, I.inclusion_rule_id) as bigint), 0)) as inclusion_rule_mask
      FROM qualified_events Q
      LEFT JOIN inclusion_events I on I.person_id = Q.person_id and I.event_id = Q.event_id
      GROUP BY Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date
    ) MG 
    WHERE (MG.inclusion_rule_mask = 1)
  ) Results
  WHERE Results.ordinal = 1
),

strategy_ends AS (
  SELECT event_id, person_id, 
         case when date_add('day', 30, start_date) > op_end_date 
              then op_end_date 
              else date_add('day', 30, start_date) 
         end as end_date
  FROM included_events
),

cohort_rows AS (
  SELECT F.person_id, F.start_date, F.end_date
  FROM (
    SELECT I.event_id, I.person_id, I.start_date, CE.end_date, 
           row_number() over (partition by I.person_id, I.event_id order by CE.end_date) as ordinal
    FROM included_events I
    JOIN (
      SELECT event_id, person_id, end_date FROM strategy_ends
    ) CE on I.event_id = CE.event_id and I.person_id = CE.person_id and CE.end_date >= I.start_date
  ) F
  WHERE F.ordinal = 1
),

final_cohort_st AS (
  SELECT person_id, start_date, end_date, 
         sum(is_start) over (partition by person_id order by start_date, is_start desc rows unbounded preceding) as group_idx
  FROM (
    SELECT person_id, start_date, end_date, 
           case when max(end_date) over (partition by person_id order by start_date rows between unbounded preceding and 1 preceding) >= start_date then 0 else 1 end as is_start
    FROM (
      SELECT person_id, start_date, end_date
      FROM cohort_rows
    ) CR
  ) ST
)

-- Final Output Select
,  cohort_results AS (
  SELECT person_id AS subject_id, 
         min(start_date) AS cohort_start_date
  FROM final_cohort_st 
  GROUP BY person_id, group_idx
),
failure_flags AS (
    SELECT 
        c.subject_id,
        MAX(CASE 
            WHEN
                -- IR Drainage
                UPPER(vf.visittype) LIKE '%ABSCESS DRAIN%' 
                OR UPPER(vf.visittype) LIKE '%PERC. TUBE%'
                OR UPPER(vf.visittype) LIKE '%TUBE CHANGE%'

                OR (UPPER(vf.primarydiagnosisname) LIKE '%PERFORAT%'
                    AND UPPER(vf.primarydiagnosisname) NOT LIKE '%WITHOUT PERFORAT%'
                    AND UPPER(vf.primarydiagnosisname) NOT LIKE '%W/O PERFORAT%')
                OR (UPPER(vf.primarydiagnosisname) LIKE '%ABSCESS%'
                    AND UPPER(vf.primarydiagnosisname) NOT LIKE '%WITHOUT%ABSCESS%'
                    AND UPPER(vf.primarydiagnosisname) NOT LIKE '%W/O%ABSCESS%')
                OR UPPER(vf.primarydiagnosisname) LIKE '%FISTULA%'

                -- ED / unscheduled acute
                OR UPPER(vf.departmentname) LIKE '%EMERGENCY%'
                OR UPPER(vf.visittype) LIKE '%ACUTE%'

                
                OR (UPPER(vf.encountertype) IN ('SURGERY','ANESTHESIA')
                    AND UPPER(vf.departmentname) LIKE '%SURG%')

            THEN 1 ELSE 0 
        END) AS is_failure
    FROM cohort_results c
    JOIN deid_omop.person p 
        ON c.subject_id = p.person_id
    JOIN deid_cdw_ucsf.patientdim pd 
        ON p.person_source_value = pd.patientepicid AND pd.iscurrent = 1
    LEFT JOIN deid_cdw_ucsf.visitfact vf 
        ON pd.patientdurablekey = vf.patientdurablekey
        AND date_diff('day', c.cohort_start_date, vf.encounterdatekeyvalue) > 0 
        AND date_diff('day', c.cohort_start_date, vf.encounterdatekeyvalue) <= 30
    GROUP BY c.subject_id
)
SELECT 
    COUNT(DISTINCT subject_id) AS total_patients,
    SUM(is_failure) AS treatment_failures,
    ROUND(100.0 * SUM(is_failure) / COUNT(DISTINCT subject_id), 1) AS failure_pct
FROM failure_flags;
