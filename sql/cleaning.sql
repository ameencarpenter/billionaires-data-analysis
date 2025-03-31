USE billionaires;

# .......... name ...................................................................................................   
 # Check if the full name exceeds 50 characters
SELECT max(length(concat(trim(first_name), ' ', trim(last_name)))) 
FROM billionaires;

# Add full name column at the start of the table
ALTER TABLE billionaires 
ADD COLUMN name VARCHAR(50) NOT NULL FIRST;

# Update full name column
UPDATE billionaires
SET NAME = concat(trim(first_name), ' ', trim(last_name));

# Remove first name and last name columns
ALTER TABLE billionaires
DROP COLUMN first_name, 
DROP COLUMN last_name;

# .......... age ......................................................................................................
-- Calculate age based on 'birth_date'  
-- Only update rows where 'age' is NULL or empty, and 'birth_date' is valid  
UPDATE billionaires  
SET age = TIMESTAMPDIFF(YEAR, date(str_to_date(birth_date, '%c/%e/%Y %k:%i')), CURDATE())  
WHERE (age IS NULL OR age = '')  
	AND (birth_date IS NOT NULL AND birth_date != '');  

-- If 'age' is still NULL or empty, replace it with the average age of existing billionaires  
UPDATE billionaires  
JOIN (  
    -- Calculate the average age (rounded) of billionaires where age is not NULL or empty  
    SELECT ROUND(AVG(age)) AS average  
    FROM billionaires  
    WHERE age IS NOT NULL AND age != ''  
) average  
SET billionaires.age = average.average  
WHERE billionaires.age IS NULL OR billionaires.age = '';  

-- Modify the 'age' column to ensure it is of type INT and not nullable.
ALTER TABLE billionaires  
MODIFY COLUMN age TINYINT UNSIGNED NOT NULL;

# .......... birth date ................................................................................................  
# there are no null values.
SELECT count(*) 
FROM billionaires 
WHERE birth_date IS NULL;

#  however there are 76 records where it's empty string.
SELECT count(*) 
FROM billionaires 
WHERE birth_date = '';

# Convert 'birth_date' to a standardized date format, keeping only the date.  
UPDATE billionaires 
SET birth_date = DATE(STR_TO_DATE(birth_date, '%c/%e/%Y %k:%i'))
WHERE birth_date IS NOT NULL AND birth_date <> '';

# Estimate 'birth_date' using the current date minus the recorded 'age' in years.  
# Applies only where 'birth_date' is NULL or empty.  
UPDATE billionaires  
SET birth_date = CURDATE() - INTERVAL age YEAR  
WHERE birth_date IS NULL OR birth_date = '';  

# Modify the 'birth_date' column to enforce the DATE type and prevent NULL values.  
ALTER TABLE billionaires  
MODIFY COLUMN birth_date DATE NOT NULL;  

# ......... gender ....................................................................................................
# Standardize gender values by converting 'M' to 'Male' and all other values to 'Female'.  
UPDATE billionaires  
SET gender = IF(gender = 'M', 'Male', 'Female');  

# Modify the 'gender' column to use VARCHAR(10) type and ensure it is not nullable.
ALTER TABLE billionaires  
MODIFY COLUMN gender VARCHAR(10) NOT NULL;

# .......... home_country .............................................................
# Update the 'home_country' column to 'unknown' where it's NULL or empty
UPDATE billionaires
SET home_country = 'unknown'
WHERE home_country IS NULL OR home_country = '';

# Alter the 'home_country' column to limit its length to 30 characters
ALTER TABLE billionaires
MODIFY COLUMN home_country VARCHAR(30) NOT NULL;

# .......... home_city .................................................................
# Update the 'home_city' column to 'unknown' where it's NULL or empty
UPDATE billionaires
SET home_city = 'unknown'
WHERE home_city IS NULL OR home_city = '';

# Alter the 'home_city' column to limit its length to 30 characters
ALTER TABLE billionaires
MODIFY COLUMN home_city VARCHAR(30) NOT NULL;

# .......... home_state .................................................................
UPDATE billionaires
SET home_state = 
    CASE
        # If the home country is not the United States, set 'home_state' to 'not-applicable'
        WHEN home_country != 'United States' THEN 'not-applicable'
        
        # If the home country is the United States and 'home_state' is NULL or empty, set it to 'unknown'
        WHEN home_country = 'United States' AND (home_state IS NULL OR TRIM(home_state) = '') THEN 'unknown'
        
        # For all other cases, keep the existing value of 'home_state'
        ELSE home_state
    END;

# Modify the 'home_state' column to be of type VARCHAR(30) and set it to NOT NULL
ALTER TABLE billionaires
MODIFY COLUMN home_state VARCHAR(30) NOT NULL;

# .......... current_country ....................................................................
# Modify the 'current_country' column to be of type VARCHAR(30) and set it to NOT NULL
ALTER TABLE billionaires
MODIFY COLUMN current_country VARCHAR(30) NOT NULL;

# .......... worth ..............................................................................
# Ensure no NULL or empty values in 'worth_in_millions' column
SELECT COUNT(*)
FROM billionaires
WHERE worth_in_millions IS NULL OR TRIM(worth_in_millions) = '';

# Ensure all values in 'worth_in_millions' are positive integers
SELECT COUNT(*) 
FROM billionaires
WHERE worth_in_millions NOT REGEXP '^[1-9][0-9]*$';

# Rename 'worth_in_millions' to 'worth' and change data type to BIGINT UNSIGNED
ALTER TABLE billionaires
CHANGE worth_in_millions worth BIGINT UNSIGNED NOT NULL;

# Update 'worth' to convert value from millions to the actual amount (multiply by 1,000,000)
UPDATE billionaires
SET worth = worth * 1000000;

# Ensure there are no outliers by checking max and min 'worth' values
# minimum should be a billion.
SELECT FORMAT(MAX(worth), 0), FORMAT(MIN(worth), 0) FROM billionaires;

# .......... industry ......................................................................
# Modify the 'industry' column to be of type VARCHAR(30) and set it to NOT NULL
ALTER TABLE billionaires
MODIFY COLUMN industry VARCHAR(30) NOT NULL;

# .......... source .........................................................................
# Modifies the 'source' column to be VARCHAR(50) and sets it as NOT NULL.
ALTER TABLE billionaires
MODIFY source VARCHAR(50) NOT NULL;

# .......... self_made ..........................................................................
# prepare 'self_made' column to convert it to tinyint.
UPDATE billionaires
SET self_made = IF(self_made = 'TRUE', 1, 0);

ALTER TABLE billionaires
MODIFY self_made TINYINT UNSIGNED NOT NULL;

# .......... country_population ...................................................................
UPDATE billionaires
SET country_population = NULL
WHERE country_population = '';

ALTER TABLE billionaires
MODIFY COLUMN country_population INT;
# .......... country_gdp .........................................................................
UPDATE billionaires
SET country_gdp = NULL
where country_gdp = '';

UPDATE billionaires
SET country_gdp = trim(REGEXP_REPLACE(country_gdp, '[,$]', ''))
WHERE country_gdp IS NOT NULL;

ALTER TABLE billionaires
MODIFY COLUMN country_gdp BIGINT;
# .......... country_life_expectancy ......................................................................
UPDATE billionaires
SET country_life_expectancy = NULL
WHERE country_life_expectancy = '';

ALTER TABLE billionaires
MODIFY COLUMN country_life_expectancy DECIMAL(3,1);

# .......... country_tax_revenue .............................................................................
UPDATE billionaires
SET country_tax_revenue = NULL
WHERE country_tax_revenue = '';

ALTER TABLE billionaires
MODIFY COLUMN country_tax_revenue DECIMAL(3,1);

# .......... country_total_tax_rate ...........................................................................
UPDATE billionaires
SET country_total_tax_rate = NULL
WHERE country_total_tax_rate = '';

ALTER TABLE billionaires
MODIFY COLUMN country_total_tax_rate DECIMAL(4,1);

# .......... country_gross_primary_education .......................................................................
UPDATE billionaires
SET country_gross_primary_education = NULL
WHERE country_gross_primary_education = '';

ALTER TABLE billionaires
MODIFY COLUMN country_gross_primary_education DECIMAL(4,1);

# .......... country_gross_tertiary_education ......................................................................
UPDATE billionaires
SET country_gross_tertiary_education = NULL
WHERE country_gross_tertiary_education = '';

ALTER TABLE billionaires
MODIFY COLUMN country_gross_tertiary_education DECIMAL(4,1);

# .......... country_cpi .............................................................................................
UPDATE billionaires
SET country_cpi = NULL
WHERE country_cpi = '';

ALTER TABLE billionaires
MODIFY COLUMN country_cpi DECIMAL(4,1);

# .......... country_latitude ........................................................................................
UPDATE billionaires
SET country_latitude = NULL
WHERE country_latitude = '';

ALTER TABLE billionaires
MODIFY COLUMN country_latitude DECIMAL(9, 6);

# .......... country_longitude ...........................................................................................
UPDATE billionaires
SET country_longitude = NULL
WHERE country_longitude = '';

ALTER TABLE billionaires
MODIFY COLUMN country_longitude DECIMAL(9, 6);

SELECT * FROM billionaires;