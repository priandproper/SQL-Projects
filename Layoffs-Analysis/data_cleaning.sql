-- ============================================================
-- SQL Data Cleaning Project - Layoffs Dataset
-- Source: https://www.kaggle.com/datasets/swaptr/layoffs-2022
-- ============================================================

-- Steps:
-- 1. Remove duplicates
-- 2. Standardize data and fix errors
-- 3. Handle null values
-- 4. Remove unnecessary rows and columns


-- ============================================================
-- SETUP: Create a staging table to work in
-- We never touch the raw data directly in case something goes wrong
-- ============================================================

CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT INTO layoffs_staging 
SELECT * FROM world_layoffs.layoffs;


-- ============================================================
-- STEP 1: Remove Duplicates
-- ============================================================

-- Use ROW_NUMBER() to number rows within groups of identical records.
-- Any row numbered > 1 is a duplicate.
SELECT *
FROM (
    SELECT company, location, industry, total_laid_off, percentage_laid_off, 
           layoff_date, stage, country, funds_raised_millions,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
                         layoff_date, stage, country, funds_raised_millions
        ) AS row_num
    FROM world_layoffs.layoffs_staging
) duplicates
WHERE row_num > 1;

-- MySQL won't let us delete directly from a subquery,
-- so we create a second staging table with row_num as a real column.

CREATE TABLE `world_layoffs`.`layoffs_staging2` (
    `company` text,
    `location` text,
    `industry` text,
    `total_laid_off` INT,
    `percentage_laid_off` text,
    `layoff_date` text,
    `stage` text,
    `country` text,
    `funds_raised_millions` int,
    `row_num` INT
);

INSERT INTO world_layoffs.layoffs_staging2
SELECT company, location, industry, total_laid_off, percentage_laid_off, 
       layoff_date, stage, country, funds_raised_millions,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
                     layoff_date, stage, country, funds_raised_millions
    ) AS row_num
FROM world_layoffs.layoffs_staging;

-- Now we can simply delete rows where row_num >= 2
-- (turn off safe mode first if needed: SET SQL_SAFE_UPDATES = 0;)
DELETE FROM world_layoffs.layoffs_staging2
WHERE row_num >= 2;

-- Verify duplicates are gone
SELECT * FROM world_layoffs.layoffs_staging2 WHERE row_num >= 2;


-- ============================================================
-- STEP 2: Standardize Data
-- ============================================================

-- ── 2a. Fix blank and null industry values ──────────────────

-- Check what we're working with
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

-- See which rows have missing industries
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL OR industry = '';

-- Convert blanks to NULL (easier to work with)
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Fill in nulls by matching on company name with rows that do have an industry
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Verify (Bally's Interactive will still be null - no other rows to pull from)
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL OR industry = '';


-- ── 2b. Standardize Crypto industry naming ──────────────────

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Verify
SELECT DISTINCT industry FROM world_layoffs.layoffs_staging2 ORDER BY industry;


-- ── 2c. Fix trailing period in country names ────────────────

-- Check for the issue
SELECT DISTINCT country FROM world_layoffs.layoffs_staging2 ORDER BY country;

-- Remove trailing periods
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- Verify
SELECT DISTINCT country FROM world_layoffs.layoffs_staging2 ORDER BY country;


-- ── 2d. Fix date column format ──────────────────────────────

-- If dates are stored as text in MM/DD/YYYY format, convert them:
-- UPDATE layoffs_staging2
-- SET layoff_date = STR_TO_DATE(layoff_date, '%m/%d/%Y');

-- In this dataset dates were already in YYYY-MM-DD format,
-- so we just change the column type from text to DATE
ALTER TABLE layoffs_staging2
MODIFY COLUMN layoff_date DATE;


-- ============================================================
-- STEP 3: Handle Null Values
-- ============================================================

-- Nulls in total_laid_off, percentage_laid_off, and funds_raised_millions
-- are left as-is. Nulls are more useful than placeholder zeros during analysis.


-- ============================================================
-- STEP 4: Remove Unnecessary Rows and Columns
-- ============================================================

-- Rows where BOTH layoff columns are null have no useful information
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete them
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Drop the row_num helper column - no longer needed
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final check - cleaned dataset ready for analysis
SELECT * FROM world_layoffs.layoffs_staging2;
