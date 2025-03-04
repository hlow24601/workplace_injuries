-- Amputations in the construction industry that took place between 2015 to 2023
-- Add naics title
WITH amputations_in_construction AS (
SELECT id, 
upa, 
event_date,
EXTRACT (year FROM event_date) AS event_year,
employer, 
zip, 
latitude, 
longitude, 
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
event, 
event_title, 
source, 
source_title
FROM severe_injuries
WHERE naics LIKE '23%' AND event_date < '2024-01-01' AND amputation > 0
)
-- Count each cause of amputation 
, amputation_counts AS (
  SELECT 
    event_year,
	naics_title, 
    event_title, 
    COUNT(*) AS cause_of_amputation
  FROM amputations_in_construction
  GROUP BY event_year, naics_title, event_title
) 

-- View the most common causes of amputation for each construction type

SELECT 
  event_year,
  naics_title, 
  event_title, 
  cause_of_amputation,
  RANK() OVER (PARTITION BY event_year, naics_title ORDER BY cause_of_amputation DESC) AS cause_rank
FROM amputation_counts
ORDER BY naics_title, cause_rank;

--- Top five causes of amputation by each construction type
SELECT * 
FROM most_common_causes
WHERE cause_rank IN (1, 2, 3, 4, 5)
ORDER BY event_year;
