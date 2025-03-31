# How many billionaires in the world as of 2023?
SELECT count(*)
FROM billionaires;

# What's the net worth of billionaires in the world as of 2023?
SELECT CONCAT(FORMAT(SUM(worth) / 1000000000,1), ' Billions') `Total Net Worth`
FROM billionaires;

# what's the average worth across all billionaires?
SELECT CONCAT(FORMAT(AVG(worth) / 1000000000, 2), ' Billions') `Average Net Worth`
FROM billionaires;

# who are the top 10 billionaires?
SELECT name,
FORMAT(worth / 1000000000, 1) worth_in_billions
FROM billionaires
ORDER BY worth DESC
LIMIT 10;

# how many billionaires for each country and what percent do they represent?
SELECT home_country `Home Country`, 
COUNT(*) Billionaires,
CONCAT(ROUND(COUNT(*) / (SELECT COUNT(*) FROM billionaires) * 100,1), '%') `AS a %`
FROM billionaires
GROUP BY home_country
ORDER BY billionaires DESC
limit 10;

# top 10 countries by wealth and what percent it represnts.
SELECT home_country `Home Country`, 
FORMAT(SUM(worth) / 1000000000,0) Billions,
CONCAT(ROUND(SUM(worth) / (SELECT SUM(worth) FROM billionaires) * 100,1), '%') `AS a %`
FROM billionaires
GROUP BY home_country
ORDER BY sum(worth) DESC
limit 10;

# by gender
SELECT gender,
COUNT(*) `Count`,
CONCAT(ROUND(COUNT(*) / (SELECT COUNT(*) FROM billionaires) * 100,2), ' %') `As a %`
FROM billionaires
GROUP BY gender;

# by industry
SELECT industry Industry,
ROUND(SUM(worth) / 1000000000, 1) `Net Worth (Billions)`
FROM billionaires
GROUP BY industry
ORDER BY SUM(worth) DESC;

# the average, min, max age
SELECT ROUND(AVG(age)) `Average Age`,
ROUND(MIN(age)) `Min Age`,
ROUND(MAX(age)) `Max Age`
FROM billionaires;


# top and bottom 5 by age.
WITH oldest AS
(
SELECT name,
age
FROM billionaires
ORDER BY age DESC
LIMIT 5
),
youngest AS
(
SELECT name,
age
FROM billionaires
ORDER BY age ASC
limit 5
) 
SELECT * FROM oldest
UNION
SELECT * FROM youngest
ORDER BY age DESC;

# self made vs inherited
SELECT IF(self_made = 1, 'Self Made', 'Inherited') Source,
COUNT(*) 
FROM billionaires
GROUP BY self_made
ORDER BY 2 DESC;

# correlation between home country's population and # of billionaires
SELECT home_country `Home Country`, 
ROUND(country_population / 1000000) `Population (Millions)`, 
COUNT(*) 
FROM billionaires
WHERE country_population IS NOT NULL
GROUP BY home_country, country_population
ORDER BY 3 DESC;

# correlation between home country's gdp and # of billionaires
SELECT home_country `Home Country`, 
ROUND(country_gdp / 1000000000) `Population (Billions)`, 
COUNT(*) 
FROM billionaires
WHERE country_population IS NOT NULL
GROUP BY home_country, country_gdp
ORDER BY 3 DESC;

# the most dominanct industry in every country
WITH country_industries AS
(
select home_country, 
industry, 
sum(worth) / 1000000000 worth
FROM billionaires 
GROUP BY home_country, industry
),
ranked AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY home_country ORDER BY worth DESC) ranking
FROM country_industries
)
SELECT home_country `Home Country`,
industry `Industry`,
ROUND(worth) `Worth (Billions)`
FROM ranked 
WHERE ranking = 1 
ORDER BY worth DESC;

# top 10 states
select home_state, 
count(*)
from billionaires
where home_country = 'United States'
group by home_state
order by 2 desc
limit 10;