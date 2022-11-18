-- first, I take a look at my dataset. 

SELECT * 
FROM threatened_spe

-- the data type of the column "Value" is varchar. I want to change its data type to interger. 
ALTER TABLE threatened_spe
ALTER COLUMN Value int;

-- next, I begin to check if there are any null columns in my dataset. 

SELECT * 
FROM threatened_spe
WHERE Threatened_species IS NULL;

SELECT * 
FROM threatened_spe
WHERE Year IS NULL;

SELECT * 
FROM threatened_spe
WHERE Series IS NULL;

SELECT * 
FROM threatened_spe
WHERE Value IS NULL;

--- then, I check the range of the column "Year" 

SELECT MIN(Year) as minYear, MAX(Year) as maxYear
FROM threatened_spe

-- I check the range of the column "Value" -- 

SELECT MIN(Value) as minValue, MAX(Value) as minYear
FROM threatened_spe

-- there exists value = 0 in the column "Value". I want to check that value is normal or not. 

SELECT * 
FROM threatened_spe
WHERE Value = 0

-- it makes sense. Nothing is cautious. 

-- next, I move to check how many types of series --- 
SELECT DISTINCT Series
FROM threatened_spe -- there are 4 different types in the series. 

SELECT COUNT( DISTINCT Threatened_species)
FROM threatened_spe -- there are 253 different countries 

--- first, I will look at the statistics of America
SELECT DISTINCT Threatened_species
FROM threatened_spe
WHERE Threatened_species LIKE 'U%'

SELECT * 
FROM threatened_spe
WHERE Threatened_species = 'United States of America'

-- I want to know which year has the higest total of threatened species: 
SELECT Max(Value)
FROM threatened_spe
WHERE Threatened_species = 'United States of America' AND Series = 'Threatened Species: Total (number)' -- 1655

SELECT Year 
FROM threatened_spe
WHERE Value = 1655 -- 2020 

-- I want to know which type has the highest number of threatened species
SELECT SUM(Value) as total_value, Series
FROM threatened_spe
WHERE Threatened_species = 'United States of America'
GROUP BY Series
ORDER BY SUM(Value) DESC 
-- Invertebrates have the highest number: 3997

-- I want to know top 5 countries and years with highest number of total threatened species
SELECT TOP(5) * 
FROM threatened_spe
WHERE Series = 'Threatened Species: Total (number)'
ORDER BY Value Desc 

-- I want to compare which type make up for the largest proportion. I create temporary table called "total_pro"
-- to hold my conditioned data. Then, I insert all the data from that temporary table into a new table called "comparing"

WITH total_pro AS (SELECT ROUND(CAST(SUM(Value) AS float) / CAST((SELECT SUM(Value)
FROM threatened_spe
WHERE Series = 'Threatened Species: Total (number)') AS float)*100, 2) as proportion
FROM threatened_spe
WHERE Series = 'Threatened Species: Vertebrates (number)'
UNION
SELECT ROUND(CAST(SUM(Value) AS float) / CAST((SELECT SUM(Value)
FROM threatened_spe
WHERE Series = 'Threatened Species: Total (number)') AS float)*100, 2) as proportion
FROM threatened_spe
WHERE Series = 'Threatened Species: Invertebrates (number)'
UNION
SELECT ROUND(CAST(SUM(Value) AS float) / CAST((SELECT SUM(Value)
FROM threatened_spe
WHERE Series = 'Threatened Species: Total (number)') AS float)*100, 2) as proportion
FROM threatened_spe
WHERE Series = 'Threatened Species: Plants (number)') 

SELECT * 
INTO comparing 
FROM total_pro

-- I add a new column to the table that I just created. 

ALTER TABLE comparing 
ADD name_species nvarchar(50)

UPDATE comparing 
SET name_species = 'Threatened Species: Vertebrates (number)'
WHERE proportion = 21.09

UPDATE comparing
SET name_species = 'Threatened Species: Plants (number)'
WHERE name_species IS NULL

UPDATE comparing
SET name_species = 'Threatened Species: Invertebrates (number)'
WHERE proportion = 35.47

SELECT * 
FROM comparing
ORDER BY proportion DESC -- it is easier for me to compare different branches of threatened species. 

-- finally, I update the value of the column "Series" from the original dataset so that it is easier for me to visualize. 

UPDATE threatened_spe
SET Series = 'Invertebrates'
WHERE Series = 'Threatened Species: Invertebrates (number)'

UPDATE threatened_spe
SET Series = 'Vertebrates'
WHERE Series = 'Threatened Species: Vertebrates (number)'

UPDATE threatened_spe
SET Series = 'Plants'
WHERE Series = 'Threatened Species: Plants (number)'

UPDATE threatened_spe
SET Series = 'Total'
WHERE Series = 'Threatened Species: Total (number)'

SELECT * 
FROM threatened_spe
WHERE Series LIKE 'Threatened Species:%'








