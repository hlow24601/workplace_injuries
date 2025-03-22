
-- Amputations in the construction industry that took place between 2015 to 2023
-- Add naics title
-- Rename event to cause_of_amputation and code to cause_code

CREATE TABLE amputations_in_construction AS
SELECT id, 
upa, 
event_date,
EXTRACT (year FROM event_date) AS event_year,
employer, 
naics, 
CASE WHEN naics = '2361%' THEN 'Residential building construction'
WHEN naics LIKE '2362%' THEN 'Nonresidential building construction'
WHEN naics LIKE '2371%' THEN 'Utility System Construction'
WHEN naics LIKE '2372%' THEN 'Land Subdivision'
WHEN naics LIKE '2373%' THEN 'Highway, Street, and Bridge Construction'
WHEN naics LIKE '2379%' THEN 'Other Heavy and Civil engineering Construction'
WHEN naics LIKE '2381%' THEN 'Foundation, Structure, and Building Exterior Contractors'
WHEN naics LIKE '2382%' THEN 'Building Equipment Contractors'
WHEN naics LIKE '2383%' THEN 'Building Finishing Contractors'
ELSE 'Other Specialty Trade Contractors' END AS naics_title,       
amputation,
nature, 
nature_title, 
part_of_body, 
part_of_body_title,
event AS cause_code, 
event_title AS cause_of_amputation, 
source, 
source_title
FROM severe_injuries
WHERE naics LIKE '23%' AND event_date < '2024-01-01' AND amputation > 0

-- View table
SELECT * 
FROM amputations_in_construction

-- Drop columns
ALTER TABLE amputations_in_construction
DROP COLUMN amputation,
DROP COLUMN nature,
DROP COLUMN nature_title;

--)
-- Count each cause of amputation by naics

WITH amputation_counts AS ( 
  SELECT 
    --event_year,
	naics_title,
	cause_of_amputation,
	cause_code,
    COUNT(*) AS overall_count_of_amputations
  FROM amputations_in_construction
  GROUP BY naics_title, cause_of_amputation, cause_code   
  ORDER BY naics_title, overall_count_of_amputations DESC
)
-- Order the causes of amputation for each construction sector


SELECT * INTO amputation_cause 
FROM (SELECT
  naics_title, 
  cause_of_amputation, 
  RANK() OVER (PARTITION BY naics_title ORDER BY overall_count_of_amputations DESC) AS cause_rank,
  overall_count_of_amputations
FROM amputation_counts
) AS amputation_cause_by_industry
ORDER BY naics_title, cause_rank


--- Top five causes of amputation by each construction type
SELECT * 
FROM amputation_cause
WHERE cause_rank IN (1, 2, 3, 4, 5)
ORDER BY naics_title, cause_rank;


-- New columns to compare total causes
ALTER TABLE amputation_cause
ADD COLUMN amputation_2022 INT,
ADD COLUMN change_from_prev_year INT

ALTER TABLE amputation_cause
ADD COLUMN amputation_2023 INT;

-- Count amputations for last two years, in the case, 2022 and 2023
UPDATE amputation_cause AS ac
SET 
    amputation_2022 = COALESCE(subq.amputation_2022, 0),
    amputation_2023 = COALESCE(subq.amputation_2023, 0)
FROM (
    SELECT 
        naics_title, 
        cause_of_amputation,
        COUNT(CASE WHEN event_year = 2022 THEN 1 END) AS amputation_2022,
        COUNT(CASE WHEN event_year = 2023 THEN 1 END) AS amputation_2023
    FROM amputations_in_construction
    GROUP BY naics_title, cause_of_amputation
) AS acsubq
WHERE ac.naics_title = acsubq.naics_title 
AND ac.cause_of_amputation = acsubq.cause_of_amputation;

-- Calculate change_from_prev_year 
UPDATE amputation_cause
SET change_from_prev_year = amputation_2023 - amputation_2022;

-- View updated table
SELECT *
FROM amputation_cause
ORDER BY naics_title, cause_rank;

--add new change column to reorder columns
ALTER TABLE amputation_cause
ADD COLUMN change_from_prev_yr_3 INT

UPDATE amputation_cause
SET change_from_prev_yr_3 = amputation_2023 - amputation_2022;

-- delete extra change_from_prev_yr
ALTER TABLE amputation_cause
DROP COLUMN change_from_prev_year

SELECT *
FROM amputation_cause

-- Rename column
ALTER TABLE amputation_cause
RENAME COLUMN change_from_prev_yr_3 TO change_from_prev_year

SELECT*
FROM amputation_cause
ORDER BY naics_title, cause_rank
