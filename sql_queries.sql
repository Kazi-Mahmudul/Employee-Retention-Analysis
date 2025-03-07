-- Create Database
create database employee_reviews;
use employee_reviews;

-- Set local infile
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

-- Create Table
CREATE TABLE reviews (
	id INT AUTO_INCREMENT PRIMARY KEY,
    firm VARCHAR(255),
    date_review DATE,
    job_title VARCHAR(255),
    current VARCHAR(255),
    location VARCHAR(255),
    overall_rating FLOAT DEFAULT NULL,
    work_life_balance FLOAT DEFAULT NULL,
    culture_values FLOAT DEFAULT NULL,
    diversity_inclusion CHAR(10) DEFAULT NULL,
    career_opp FLOAT DEFAULT NULL,
    comp_benefits FLOAT DEFAULT NULL,
    senior_mgmt FLOAT DEFAULT NULL,
    recommend CHAR(10) DEFAULT NULL,
    ceo_approv CHAR(10) DEFAULT NULL,
    outlook CHAR(10) DEFAULT NULL,
    headline VARCHAR(4000),
    pros TEXT,
    cons TEXT
);

DROP TABLE reviews;

-- Load Table in SQL
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/glassdoor_reviews.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'  -- Use '\n' if needed
IGNORE 1 ROWS
(@firm, @date_review, @job_title, @current, @location, @overall_rating, 
 @work_life_balance, @culture_values, @diversity_inclusion, @career_opp, 
 @comp_benefits, @senior_mgmt, @recommend, @ceo_approv, @outlook, @headline, @pros, @cons)
SET
    firm = NULLIF(@firm, ''),
    date_review = DATE_ADD('1899-12-30', INTERVAL @date_review DAY),  
    job_title = NULLIF(@job_title, ''),
    current = NULLIF(@current, ''),
    location = NULLIF(@location, ''),
    overall_rating = NULLIF(@overall_rating, ''),
    work_life_balance = NULLIF(@work_life_balance, ''),
    culture_values = NULLIF(@culture_values, ''),
    diversity_inclusion = NULLIF(@diversity_inclusion, ''),
    career_opp = NULLIF(@career_opp, ''),
    comp_benefits = NULLIF(@comp_benefits, ''),
    senior_mgmt = NULLIF(@senior_mgmt, ''),
    recommend = NULLIF(@recommend, ''),
    ceo_approv = NULLIF(@ceo_approv, ''),
    outlook = NULLIF(@outlook, ''),
    headline = NULLIF(@headline, ''),
    pros = NULLIF(@pros, ''),
    cons = NULLIF(@cons, '');

SELECT * FROM reviews LIMIT 100;

-- Data Cleaning

-- Finding missing categorical values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN firm IS NULL OR firm = '' THEN 1 ELSE 0 END) AS missing_firm,
    SUM(CASE WHEN job_title IS NULL OR job_title = '' THEN 1 ELSE 0 END) AS missing_job_title,
    SUM(CASE WHEN current IS NULL OR current = '' THEN 1 ELSE 0 END) AS missing_current,
    SUM(CASE WHEN location IS NULL OR location = '' THEN 1 ELSE 0 END) AS missing_location
FROM reviews;

-- Exiting safe mode
SET SQL_SAFE_UPDATES = 0;

-- Updating the missing values
UPDATE reviews
SET location = 'unknown'
WHERE location IS NULL OR location = '';

-- Finding missing numerical values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN overall_rating IS NULL THEN 1 ELSE 0 END) AS missing_overall_rating,
    SUM(CASE WHEN work_life_balance IS NULL THEN 1 ELSE 0 END) AS missing_work_life_balance,
    SUM(CASE WHEN culture_values IS NULL THEN 1 ELSE 0 END) AS missing_culture_values,
    SUM(CASE WHEN diversity_inclusion IS NULL THEN 1 ELSE 0 END) AS missing_diversity_inclusion,
    SUM(CASE WHEN career_opp IS NULL THEN 1 ELSE 0 END) AS missing_career_opp,
    SUM(CASE WHEN comp_benefits IS NULL THEN 1 ELSE 0 END) AS missing_comp_benefits,
    SUM(CASE WHEN senior_mgmt IS NULL THEN 1 ELSE 0 END) AS missing_senior_mgmt
FROM reviews;

-- Updating the missing values
UPDATE reviews
SET
	work_life_balance = (
    SELECT avg_value FROM (SELECT ROUND(AVG(work_life_balance), 1) AS avg_value FROM reviews) AS temp
    )
WHERE work_life_balance IS NULL;

UPDATE reviews
SET 
	culture_values = (
    SELECT avg_value FROM (SELECT ROUND(AVG(culture_values),1) AS avg_value FROM reviews) AS temp
    )
WHERE culture_values IS NULL;

UPDATE reviews
SET
	diversity_inclusion = (
    SELECT avg_value FROM (SELECT ROUND(AVG(diversity_inclusion), 1) AS avg_value FROM reviews) AS temp
    )
WHERE diversity_inclusion IS NULL;

UPDATE reviews
SET
	career_opp = (
    SELECT avg_value FROM (SELECT ROUND(AVG(career_opp), 1) AS avg_value FROM reviews) AS temp
    )
WHERE career_opp IS NULL;

UPDATE reviews
SET
	comp_benefits = (
    SELECT avg_value FROM (SELECT ROUND(AVG(comp_benefits), 1) AS avg_value FROM reviews) AS temp
    )
WHERE comp_benefits IS NULL;

UPDATE reviews
SET 
	senior_mgmt = (
    SELECT avg_value FROM (SELECT ROUND(AVG(senior_mgmt), 1) AS avg_value FROM reviews) AS temp
    )
WHERE senior_mgmt IS NULL;

SELECT ROUND(AVG(senior_mgmt), 1) AS avg_value FROM reviews;
SELECT senior_mgmt FROM reviews WHERE senior_mgmt > 10;

-- Checking for duplicates
SELECT firm, date_review, job_title, current, location, COUNT(*)
FROM reviews
GROUP BY firm, date_review, job_title, current, location
HAVING count(*) > 1;

-- Deleting the duplicates
DELETE r
FROM reviews r
LEFT JOIN (
	SELECT MIN(id) AS min_id
    FROM reviews 
    GROUP BY firm, date_review, job_title, current, location
	) AS existing_rows
ON r.id = existing_rows.min_id
WHERE existing_rows.min_id IS NULL;

-- Missing reviews
SELECT
SUM(CASE WHEN headline IS NULL OR headline = '' THEN 1 ELSE 0 END) AS missing_headline,
SUM(CASE WHEN pros IS NULL OR pros = '' THEN 1 ELSE 0 END) AS missing_pros,
SUM(CASE WHEN cons IS NULL OR cons = '' THEN 1 ELSE 0 END) AS missing_cons
FROM reviews;

-- Updating missing reviews
UPDATE reviews
SET headline = 'undefined'
WHERE headline IS NULL OR headline = '';

UPDATE reviews
SET cons = 'undefined'
WHERE cons IS NULL OR cons = '';


-- Data Transformation

SELECT DISTINCT location 
FROM reviews 
ORDER BY location;

-- Creating categorical bucket for Company Size
ALTER TABLE reviews
ADD COLUMN company_size VARCHAR(20);

-- adding company size 
UPDATE reviews r
INNER JOIN
(SELECT firm, COUNT(*) AS firm_count
FROM reviews
GROUP BY firm) AS sub
ON r.firm = sub.firm
SET r.company_size = 
	CASE WHEN sub.firm_count <= 50 THEN 'Small'
    WHEN sub.firm_count BETWEEN 51 AND 200 THEN 'Mid-Size'
    ELSE 'Large'
    END;
    
SELECT company_size, COUNT(*)
FROM reviews
WHERE company_size = 'Mid-Size';

SELECT firm, company_size 
FROM reviews
GROUP BY firm, company_size;

-- Creating Sentimental score for reviews
ALTER TABLE reviews
ADD COLUMN sentimental_score FLOAT DEFAULT NULL;

UPDATE reviews
SET sentimental_score = 
	CASE WHEN CHAR_LENGTH(pros) > CHAR_LENGTH(cons) THEN 1 
    WHEN CHAR_LENGTH(pros) = CHAR_LENGTH(cons) THEN 0
    ELSE -1
    END;
    
SELECT sentimental_score, COUNT(*)
FROM reviews
GROUP BY sentimental_score;

-- Adding review year and month
ALTER TABLE reviews
ADD COLUMN review_year INT;

ALTER TABLE reviews
ADD COLUMN review_month INT;

UPDATE reviews
SET review_year = YEAR(date_review),
	review_month = MONTH(date_review);
    
SELECT review_year, COUNT(*)
FROM reviews
GROUP BY review_year
ORDER BY review_year DESC;

SELECT current FROM reviews
WHERE current = 'Former Employee, less than 1 year' LIMIT 100;

-- Adding experience level
ALTER TABLE reviews
ADD COLUMN experience_level VARCHAR(20);

UPDATE reviews
SET experience_level = 
     CASE WHEN current LIKE '%3 years%' OR current LIKE '%4 years%' OR current LIKE '%5 years%' OR current LIKE 'Current Employee' THEN 'Mid-level'
    WHEN current LIKE '%1 year%' OR current LIKE '%2 years%' THEN 'Entry'
    WHEN current LIKE 'Former Employee' THEN 'Entry or Mid-Level'
	ELSE 'Senior'
	END;
    
SELECT current, experience_level
FROM reviews 
WHERE experience_level = 'Senior';

ALTER TABLE reviews
DROP COLUMN experience_level;

SHOW WARNINGS;

SELECT * FROM reviews LIMIT 100;


-- Key Analysis Questions

-- 1. Key factors affecting reviews in Small, Mid-Size, Large Companies?
SELECT company_size, COUNT(*)
FROM reviews
GROUP BY company_size;

SELECT company_size, 
	ROUND(AVG(overall_rating), 2) AS avg_overall_rating,
    ROUND(AVG(work_life_balance), 2) AS avg_work_life_balance,
    ROUND(AVG(culture_values), 2) AS avg_culture_values,
    ROUND(AVG(diversity_inclusion), 2) AS avg_diversity_inclusion,
    ROUND(AVG(career_opp), 2) AS avg_career_opp,
    ROUND(AVG(comp_benefits), 2) AS avg_comp_benefits,
    ROUND(AVG(senior_mgmt), 2) AS avg_senior_mgmt
FROM reviews
GROUP BY company_size
ORDER BY avg_overall_rating DESC;

-- 2. How company reviews evolve over time?
SELECT 
	review_year, 
    review_month,
    ROUND(AVG(overall_rating), 2) AS avg_overall_rating,
    ROUND(AVG(work_life_balance), 2) AS avg_work_life_balance,
    ROUND(AVG(career_opp), 2) AS avg_career_growth
FROM reviews
GROUP BY review_year, review_month
ORDER BY review_year, review_month;
	
-- 3. Do senior employees in large companies prioritize work-life balance over salary?
SELECT 
	experience_level, 
	company_size,
    ROUND(AVG(work_life_balance), 2) AS avg_work_life_balance,
	ROUND(AVG(comp_benefits), 2) AS avg_comp_benefits
FROM reviews
WHERE experience_level = 'Senior' AND company_size = 'Large'
GROUP BY experience_level, company_size;

-- 4. Do mid-level startup company employees prioritize growth over salary?
SELECT 
	experience_level,
    company_size,
    ROUND(AVG(career_opp), 2) AS avg_career_growth,
    ROUND(AVG(comp_benefits), 2) AS avg_salary_benefits
FROM reviews
WHERE experience_level = 'Mid-Level' AND company_size IN ('Small', 'Mid-Size')
GROUP BY experience_level, company_size;

-- 5. Why do employees leave companies?
SELECT
    'Work-Life Balance' AS reason, ROUND(AVG(work_life_balance), 2) AS avg_rating FROM reviews WHERE current LIKE '%Former Employee%'
UNION ALL
SELECT
    'Career Growth', ROUND(AVG(career_opp), 2) FROM reviews WHERE current LIKE '%Former Employee%'
UNION ALL
SELECT
    'Salary & Benefits', ROUND(AVG(comp_benefits), 2) FROM reviews WHERE current LIKE '%Former Employee%'
UNION ALL
SELECT
    'Senior Management', ROUND(AVG(senior_mgmt), 2) FROM reviews WHERE current LIKE '%Former Employee%'
UNION ALL
SELECT
    'Overall Rating', ROUND(AVG(overall_rating), 2) FROM reviews WHERE current LIKE '%Former Employee%'



