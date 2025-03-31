use billionaires;

# Creating a new table for data cleaning to keep the original data intact for reference or restoration if needed.
drop table if exists billionaires;
create table billionaires like billionaires_staging;
insert into billionaires select * from billionaires_staging;

# The 'category' and 'industries' columns contain redundant data. 
# The 'industries' column will be removed.

SELECT category, industries 
FROM billionaires 
WHERE category != industries;

ALTER TABLE billionaires 
DROP COLUMN industries;

# 796 rows have a 'personName' that differs from the concatenation of 'firstName' and 'lastName', 
# but the values are similar. Since 'personName' is redundant, it will be removed.

SELECT COUNT(*)
FROM billionaires
WHERE personName != CONCAT(firstName, " ", lastName);

SELECT personName, firstName, lastName
FROM billionaires
WHERE personName != CONCAT(firstName, " ", lastName);

ALTER TABLE billionaires 
DROP COLUMN personName;

-- There are 316 rows where 'country' differs from 'countryOfCitizenship'. 
-- Since this distinction is needed, no column removal will be performed.

SELECT COUNT(*) 
FROM billionaires 
WHERE country != countryOfCitizenship;

SELECT country, countryOfCitizenship 
FROM billionaires 
WHERE country != countryOfCitizenship;


# The 'birthYear', 'birthMonth', and 'birthDay' columns are redundant as the 'birthDate' column provides the same information. 
# These columns will be removed to streamline the data.

SELECT birthDate, birthYear, birthMonth, birthDay 
FROM billionaires;

ALTER TABLE billionaires 
DROP COLUMN birthYear, 
DROP COLUMN birthMonth,
DROP COLUMN birthDay;

# All values in the 'date' column are identical - 2023-04-04.
# As it provides no additional value, the 'date' column will be removed.

SELECT DISTINCT `date` 
FROM billionaires;

ALTER TABLE billionaires 
DROP COLUMN `date`;

# The 'status' column categorizes the source of wealth, but we have another column 'selfmade' that indicates whether they are self-made (true or false). 
# Since the 'status' column lacks a clear reference for each value, it will be removed.

SELECT DISTINCT status 
FROM billionaires;

ALTER TABLE billionaires 
DROP COLUMN status;

# The 'residenceStateRegion' column is unnecessary and will be removed.

ALTER TABLE billionaires 
DROP COLUMN residenceStateRegion;

# The 'cpi_change_country' column is unnecessary and will be removed.

ALTER TABLE billionaires 
DROP COLUMN cpi_change_country;

# The 'ï»¿rank' column's accuracy is uncertain. 
# It will be removed, and a new ranking will be created for better accuracy.

ALTER TABLE billionaires 
DROP COLUMN `ï»¿rank`;

# Drop 'organization' and 'title' columns due to 88% missing values
ALTER TABLE billionaires
DROP COLUMN organization,
DROP COLUMN title;

# Renaming columns in the 'billionaires' table to improve clarity and consistency.

ALTER TABLE billionaires
    RENAME COLUMN finalWorth TO worth_in_millions,
    RENAME COLUMN category TO industry,
    RENAME COLUMN country TO home_country,
    RENAME COLUMN city TO home_city,
    RENAME COLUMN countryOfCitizenship TO current_country,
    RENAME COLUMN selfMade TO self_made,
    RENAME COLUMN birthDate TO birth_date,
    RENAME COLUMN lastName TO last_name,
    RENAME COLUMN firstName TO first_name,
    RENAME COLUMN state TO home_state,
    RENAME COLUMN cpi_country TO country_cpi,
    RENAME COLUMN gdp_country TO country_gdp,
    RENAME COLUMN gross_tertiary_education_enrollment TO country_gross_tertiary_education,
    RENAME COLUMN gross_primary_education_enrollment_country TO country_gross_primary_education,
    RENAME COLUMN life_expectancy_country TO country_life_expectancy,
    RENAME COLUMN tax_revenue_country_country TO country_tax_revenue,
    RENAME COLUMN total_tax_rate_country TO country_total_tax_rate,
    RENAME COLUMN population_country TO country_population,
    RENAME COLUMN latitude_country TO country_latitude,
    RENAME COLUMN longitude_country TO country_longitude;
 
        
# Rearranging columns in the 'billionaires' table to improve the logical flow and consistency.

ALTER TABLE billionaires
    MODIFY COLUMN first_name TEXT,
    MODIFY COLUMN last_name TEXT AFTER first_name,
    MODIFY COLUMN birth_date TEXT AFTER last_name,
    MODIFY COLUMN age TEXT AFTER birth_date,
    MODIFY COLUMN gender TEXT AFTER age,
    MODIFY COLUMN home_country TEXT AFTER gender,
    MODIFY COLUMN home_city TEXT AFTER home_country,
    MODIFY COLUMN home_state TEXT AFTER home_city,
    MODIFY COLUMN current_country TEXT AFTER home_state,
    MODIFY COLUMN worth_in_millions TEXT AFTER current_country,
    MODIFY COLUMN industry TEXT AFTER worth_in_millions,
    MODIFY COLUMN source TEXT AFTER industry,
    MODIFY COLUMN self_made TEXT AFTER source,
    MODIFY COLUMN country_population TEXT AFTER self_made,
    MODIFY COLUMN country_gdp TEXT AFTER country_population,
    MODIFY COLUMN country_life_expectancy TEXT AFTER country_gdp,
    MODIFY COLUMN country_tax_revenue TEXT AFTER country_life_expectancy,
    MODIFY COLUMN country_total_tax_rate TEXT AFTER country_tax_revenue,
    MODIFY COLUMN country_gross_primary_education TEXT AFTER country_total_tax_rate,
    MODIFY COLUMN country_gross_tertiary_education TEXT AFTER country_gross_primary_education,
    MODIFY COLUMN country_cpi TEXT AFTER country_gross_tertiary_education,
    MODIFY COLUMN country_latitude TEXT AFTER country_cpi,
    MODIFY COLUMN country_longitude TEXT AFTER country_latitude;