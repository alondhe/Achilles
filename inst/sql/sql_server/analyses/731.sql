-- 731	Number of persons by drug exposure start date (YYYYMMDD), by drug_concept_id

--HINT DISTRIBUTE_ON_KEY(stratum_1)
WITH rawData AS (
  SELECT
    drug_concept_id as stratum_1,
	(YEAR(drug_exposure_start_date)*100 + MONTH(drug_exposure_start_date))*100 + DAY(drug_exposure_start_date) as stratum_2,
    COUNT_BIG(distinct PERSON_ID) as count_value
  FROM
  @cdmDatabaseSchema.drug_exposure
  GROUP BY drug_concept_id,
   (YEAR(drug_exposure_start_date)*100 + MONTH(drug_exposure_start_date))*100 + DAY(drug_exposure_start_date)
)
SELECT
  731 as analysis_id,
  cast(stratum_1 as varchar(255)) as stratum_1,
  cast(stratum_2 as varchar(255)) as stratum_2,
  cast(null as varchar(255)) as stratum_3,
  cast(null as varchar(255)) as stratum_4,
  cast(null as varchar(255)) as stratum_5,
  count_value
INTO @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_731
FROM rawData;