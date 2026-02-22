-- ============================================================
-- SQL EDA Project - Layoffs Dataset
-- ============================================================

-- Preview the cleaned data
SELECT *
FROM world_layoffs.layoffs_staging2;

-- ── BASIC EXPLORATION ────────────────────────────────────────

-- Finding the single largest layoff event
SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;

-- Range of percentage laid off
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- Companies that laid off 100% of their workforce (shut down completely)
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

-- Same but ordered by funds raised to see which big companies still went under
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- ── GROUP BY ANALYSIS ────────────────────────────────────────

-- Companies with the most total layoffs
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Locations with the most total layoffs
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- Countries with the most total layoffs
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total layoffs per year
SELECT YEAR(layoff_date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(layoff_date)
ORDER BY 1 ASC;

-- Industries hit hardest
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Layoffs by company stage
SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- ── ADVANCED QUERIES ─────────────────────────────────────────

-- Top 3 companies with most layoffs per year
WITH Company_Year AS 
(
  SELECT company, YEAR(layoff_date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(layoff_date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Rolling total of layoffs per month
WITH DATE_CTE AS 
(
SELECT SUBSTRING(layoff_date, 1, 7) AS dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) AS rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;