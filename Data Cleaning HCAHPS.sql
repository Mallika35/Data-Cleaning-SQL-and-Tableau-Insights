CREATE TABLE "sample_data"."Hospital Data".Tableau_File AS

WITH hospital_beds_prep AS
(
SELECT                                                               -- Converting provider_ccn (INTEGER) to TEXT using CAST                                                          
     LPAD(CAST(provider_ccn AS text),6,'0') as provider_ccn,         -- Adding leading zeros with LPAD to ensure 6-character text representation
	 to_date(fiscal_year_begin_date,'MM/DD/YYYY') AS fiscal_year_begin_date,          -- changing text to date
	 to_date(fiscal_year_end_date, 'MM/DD/YYYY') AS fiscal_year_end_date,
     number_of_beds,
	 ROW_NUMBER() OVER(PARTITION BY provider_ccn ORDER BY to_date(fiscal_year_end_date, 'MM/DD/YYYY')DESC) AS nthrow
FROM "sample_data"."Hospital Data".hospital_beds
)   
SELECT
     LPAD(CAST(facility_id AS text),6,'0') AS provider_ccn,
	 TO_DATE(start_date, 'MM/DD/YYYY') AS start_date_converted,
	 TO_DATE(end_date, 'MM/DD/YYYY') AS end_date_converted,
     hcahps.*,
	 beds.fiscal_year_begin_date AS beds_start_report_peroid,
     beds.fiscal_year_end_date AS beds_end_report_peroid,
     beds.number_of_beds
FROM "sample_data"."Hospital Data".HCAHPS_data AS hcahps
LEFT JOIN hospital_beds_prep AS beds
ON beds.provider_ccn = LPAD(CAST(facility_id AS text),6,'0')
AND  beds.nthrow =  1
