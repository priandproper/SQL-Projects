/* Sample check */
SELECT * 
FROM marketing_staging2 
LIMIT 5;
/* Confirms table structure and data quality */


--------------------------------------------------

/* Customer profile */
SELECT 
  ROUND(AVG(2024 - Year_Birth)) AS Avg_Age,
  ROUND(AVG(Income)) AS Avg_Income,
  ROUND(AVG(Kidhome + Teenhome)) AS Avg_Kids,
  ROUND(AVG(Recency)) AS avg_days_since_last_purchase
FROM marketing_staging2;
/* Establishes baseline demographic and behavioral averages */


--------------------------------------------------

/* Marital status distribution */
SELECT Marital_Status, COUNT(*) AS count
FROM marketing_staging2
GROUP BY Marital_Status
ORDER BY count DESC;
/* Majority of customers are in relationships, suggesting household purchasing influence */


--------------------------------------------------

/* Education distribution */
SELECT Education, COUNT(*) AS count
FROM marketing_staging2
GROUP BY Education
ORDER BY count DESC;
/* Customer base skews highly educated */


--------------------------------------------------

/* Country distribution */
SELECT Country, COUNT(*) AS count,
ROUND(AVG(Income)) AS avg_income
FROM marketing_staging2
GROUP BY Country
ORDER BY count DESC;
/* Identifies geographic concentration and income differences */


--------------------------------------------------

/* Product category averages */
SELECT 
    ROUND(AVG(MntWines)) AS avg_spent_wines,
    ROUND(AVG(MntFruits)) AS avg_spent_fruits,
    ROUND(AVG(MntMeatProducts)) AS avg_spent_meat,
    ROUND(AVG(MntFishProducts)) AS avg_spent_fish,
    ROUND(AVG(MntSweetProducts)) AS avg_spent_sweets,
    ROUND(AVG(MntGoldProds)) AS avg_spent_gold
FROM marketing_staging2;
/* Wine and meat categories drive the highest spend */


--------------------------------------------------

/* Channel behavior */
SELECT 
    ROUND(AVG(NumWebPurchases)) AS avg_web_purchases,
    ROUND(AVG(NumStorePurchases)) AS avg_store_purchases,
    ROUND(AVG(NumCatalogPurchases)) AS avg_catalog_purchases,
    ROUND(AVG(NumDealsPurchases)) AS avg_deal_purchases,
    ROUND(AVG(NumWebVisitsMonth)) AS avg_web_visits
FROM marketing_staging2;
/* Store purchases dominate; web activity shows strong browsing behavior */


--------------------------------------------------

/* Campaign performance totals */
SELECT 
    SUM(AcceptedCmp1) AS campaign_1,
    SUM(AcceptedCmp2) AS campaign_2,
    SUM(AcceptedCmp3) AS campaign_3,
    SUM(AcceptedCmp4) AS campaign_4,
    SUM(AcceptedCmp5) AS campaign_5,
    SUM(Response) AS last_campaign
FROM marketing_staging2;
/* Overall campaign acceptance volume across all campaigns */


--------------------------------------------------

/* Total spend per customer */
SELECT 
    ID,
    MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds AS total_spend
FROM marketing_staging2
ORDER BY total_spend DESC
LIMIT 10;
/* Identifies highest-spending customers */


--------------------------------------------------

/* Average total spend by education */
SELECT 
    Education,
    ROUND(AVG(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds)) AS avg_total_spend
FROM marketing_staging2
GROUP BY Education
ORDER BY avg_total_spend DESC;
/* Compares spending power across education levels */


--------------------------------------------------

/* Average total spend by marital status */
SELECT 
    Marital_Status,
    ROUND(AVG(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds)) AS avg_total_spend
FROM marketing_staging2
GROUP BY Marital_Status
ORDER BY avg_total_spend DESC;
/* Evaluates impact of relationship status on spending */


--------------------------------------------------

/* Spend and income by number of children */
SELECT 
    Kidhome + Teenhome AS num_kids,
    ROUND(AVG(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds)) AS avg_total_spend,
    ROUND(AVG(Income)) AS avg_income
FROM marketing_staging2
GROUP BY num_kids
ORDER BY num_kids ASC;
/* Assesses how dependents influence income and purchasing behavior */


--------------------------------------------------

/* Country-level spend comparison */
SELECT 
    Country,
    ROUND(AVG(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds)) AS avg_total_spend
FROM marketing_staging2
GROUP BY Country
ORDER BY avg_total_spend DESC;
/* Identifies highest-value markets */


--------------------------------------------------

/* Income segment vs campaign responsiveness */
SELECT 
    CASE 
        WHEN Income < 30000 THEN 'Low'
        WHEN Income BETWEEN 30000 AND 60000 THEN 'Middle'
        WHEN Income > 60000 THEN 'High'
    END AS income_segment,
    ROUND(AVG(AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5)) AS avg_campaigns_accepted,
    COUNT(*) AS customer_count
FROM marketing_staging2
GROUP BY income_segment
ORDER BY avg_campaigns_accepted DESC;
/* Compares campaign engagement across income groups */


--------------------------------------------------

/* Most campaign-responsive customers */
SELECT 
    ID,
    AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 AS total_campaigns_accepted,
    MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds AS total_spend
FROM marketing_staging2
ORDER BY total_campaigns_accepted DESC
LIMIT 10;
/* Highlights customers with highest engagement */