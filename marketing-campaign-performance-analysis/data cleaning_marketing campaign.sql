-- Marketing Campaign Data Cleaning
-- Dataset: Maven Analytics Marketing Campaign Results

-- first look at what we're working with
SELECT COUNT(*) FROM marketing_data.marketing;
SELECT * FROM marketing;

-- create a staging table so we never touch the raw data
DROP TABLE IF EXISTS marketing_staging;


CREATE TABLE marketing_staging
LIKE marketing;

INSERT INTO marketing_staging
SELECT * FROM marketing;

SELECT COUNT(*) FROM marketing_staging;

-- check for duplicates
-- excluding ID from partition because each row has a unique ID
-- so including it would hide real duplicates
SELECT *
FROM (
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY Year_Birth, Education, Marital_Status, Income, 
        Kidhome, Teenhome, Dt_Customer, Recency, MntWines, MntFruits, 
        MntMeatProducts, MntFishProducts, MntSweetProducts, MntGoldProds,
        NumDealsPurchases, NumWebPurchases, NumCatalogPurchases, 
        NumStorePurchases, NumWebVisitsMonth, AcceptedCmp1, AcceptedCmp2,
        AcceptedCmp3, AcceptedCmp4, AcceptedCmp5, Response, Complain, Country
        ORDER BY Dt_Customer)
    AS row_num
    FROM marketing_staging
) duplicates
WHERE row_num > 1;

-- create staging2 with row_num as a real column so we can delete from it
CREATE TABLE marketing_data.marketing_staging2 (
  ID TEXT, Year_Birth TEXT, Education TEXT, Marital_Status TEXT,
  Income TEXT, Kidhome TEXT, Teenhome TEXT, Dt_Customer TEXT,
  Recency TEXT, MntWines TEXT, MntFruits TEXT, MntMeatProducts TEXT,
  MntFishProducts TEXT, MntSweetProducts TEXT, MntGoldProds TEXT,
  NumDealsPurchases TEXT, NumWebPurchases TEXT, NumCatalogPurchases TEXT,
  NumStorePurchases TEXT, NumWebVisitsMonth TEXT, AcceptedCmp3 TEXT,
  AcceptedCmp4 TEXT, AcceptedCmp5 TEXT, AcceptedCmp1 TEXT,
  AcceptedCmp2 TEXT, Response TEXT, Complain TEXT, Country TEXT,
  row_num INT
);

INSERT INTO marketing_data.marketing_staging2
SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY Year_Birth, Education, Marital_Status, Income, 
        Kidhome, Teenhome, Dt_Customer, Recency, MntWines, MntFruits, 
        MntMeatProducts, MntFishProducts, MntSweetProducts, MntGoldProds,
        NumDealsPurchases, NumWebPurchases, NumCatalogPurchases, 
        NumStorePurchases, NumWebVisitsMonth, AcceptedCmp1, AcceptedCmp2,
        AcceptedCmp3, AcceptedCmp4, AcceptedCmp5, Response, Complain, Country
        ORDER BY Dt_Customer)
    AS row_num
FROM marketing_staging;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM marketing_staging2 WHERE row_num >= 2;

-- verify duplicates are gone
SELECT COUNT(*) FROM marketing_staging2 WHERE row_num >= 2;
SET SQL_SAFE_UPDATES = 1;

-- standardize data
-- education looks fine
SELECT DISTINCT Education FROM marketing_staging2 ORDER BY Education;

-- marital status has some weird values - Alone, Absurd, YOLO
SELECT Marital_Status, COUNT(*) AS count
FROM marketing_staging2
GROUP BY Marital_Status
ORDER BY count DESC;

SET SQL_SAFE_UPDATES = 0;
UPDATE marketing_staging2
SET Marital_Status = 'Single'
WHERE Marital_Status = 'Alone';

UPDATE marketing_staging2
SET Marital_Status = NULL
WHERE Marital_Status IN ('Absurd', 'YOLO');

-- verify
SELECT Marital_Status, COUNT(*) AS count
FROM marketing_staging2
GROUP BY Marital_Status
ORDER BY count DESC;

-- country looks clean
SELECT Country, COUNT(*) AS count
FROM marketing_staging2
GROUP BY Country
ORDER BY count DESC;

-- 24 null income values out of ~2200 rows, leaving as NULL
SELECT COUNT(*) 
FROM marketing_staging2
WHERE Income IS NULL OR Income = '';

-- dates are stored as text, need to convert to DATE type
UPDATE marketing_staging2
SET Dt_Customer = STR_TO_DATE(Dt_Customer, '%m/%d/%y');

ALTER TABLE marketing_staging2
MODIFY COLUMN Dt_Customer DATE;

-- verify date fix
SELECT Dt_Customer FROM marketing_staging2 LIMIT 10;

UPDATE marketing_staging2
SET Income = NULL
WHERE Income = '' OR Income = '0';

ALTER TABLE marketing_staging2
MODIFY COLUMN Income DECIMAL(10,2);

-- convert all numeric columns from text to proper data types
ALTER TABLE marketing_staging2
MODIFY COLUMN Year_Birth INT,
MODIFY COLUMN Kidhome INT,
MODIFY COLUMN Teenhome INT,
MODIFY COLUMN Recency INT,
MODIFY COLUMN MntWines INT,
MODIFY COLUMN MntFruits INT,
MODIFY COLUMN MntMeatProducts INT,
MODIFY COLUMN MntFishProducts INT,
MODIFY COLUMN MntSweetProducts INT,
MODIFY COLUMN MntGoldProds INT,
MODIFY COLUMN NumDealsPurchases INT,
MODIFY COLUMN NumWebPurchases INT,
MODIFY COLUMN NumCatalogPurchases INT,
MODIFY COLUMN NumStorePurchases INT,
MODIFY COLUMN NumWebVisitsMonth INT,
MODIFY COLUMN AcceptedCmp1 INT,
MODIFY COLUMN AcceptedCmp2 INT,
MODIFY COLUMN AcceptedCmp3 INT,
MODIFY COLUMN AcceptedCmp4 INT,
MODIFY COLUMN AcceptedCmp5 INT,
MODIFY COLUMN Response INT,
MODIFY COLUMN Complain INT;

-- drop row_num now that we're done with it
ALTER TABLE marketing_staging2
DROP COLUMN row_num;

-- final check
SELECT * FROM marketing_staging2 LIMIT 10;
SELECT COUNT(*) FROM marketing_staging2;