# workplace_injuries
This is a work in progress. Updates will be commited periodically.

## Description of the data source
This dataset of severe workplace injuries was obtained from  the **U.S. Occupational Safety and Health Administration (OHSA)**. The OHSA requires all employers to report severe workplace injuries, which is defined as an amputation, hospitalization, or loss of an eye. The data set thus contains all reported severe injuries under federal OHSA jurisdiction. 
The data was extracted on Feburary 23, 2025, with the data being reported for incidents taking places from Jan 2015 to April 2024. 

Data source: https://www.osha.gov/severe-injury-reports
Workplace injuries are coded according to the **Occupational Injury and Illness Classification System (OIICS)**. 

## Project overview
1. To examine trends in workplace injuries leading to amputations in the construction industry; specifically by a) industry type (based on the NAICS), b) cause of injury (based on the OIICS), and c) seasonality
2. As we will be comparing injuries by year, only full calender years will be considered in the analysis. Thus, 2024 data, which only covers incidents up to the month of April will be excluded.

## Project dashboard
An interactive dashboard has been created using Tableau: [Work-related Amputations in the Construction Industry, 2015 - 2023](https://public.tableau.com/views/AmputationsintheConstructionIndustry2015-2023/Dashboard32?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

This dashboard:
* Highlights the *top 5 causes* of amputations, customizable by construction sector/s and year/s
* Displays trends (if any) in the *yearly* total number of amputations by sector, customizable by cause of amputation
* Displays the total number of ampuations by *month*, customizable by sector/s and year/s, highlighting the top 3 months with the highest number of amputations 
  
## SQL script
The SQL script saved in this project folder accomplishes the following on Postgre:
1. Creates table, **amputations_in_construction** from the source data selecting only incidents leading to amputations
  * Selects only incidates that occured between 2015 - 2023
  * Adding the full NAICS name next to each corresponding NAICS code for ease of view when exported as csv
    
2. Executes a query showing displaying each cause of amputation and the number of amputations each cause was responsible for by each construction sector
  * Results are ordered by the number of amputations
  * The results of this query formed csv file used to create the Tableau dashboard described in the section above

3. Contains a trigger, annual_amputation_update, that automatically updates amputations_in_construction with updates to the source file by year of incident
