# Maven Marketing Campaign Analysis

**Tools:** MySQL · Tableau  
**Dataset:** Maven Analytics — 2,193 customers, 25 fields  
**Live Dashboard:** [View on Tableau Public](https://public.tableau.com/app/profile/priyanka.tambe2532/vizzes)

---

## Business Question

Which customers are most valuable, which campaigns are working, and how should the business allocate its marketing budget to maximize ROI?

---

## Key Findings

**Customers**
- Average customer is 55 years old, married, highly educated, with a household income of ~$52K and one dependent at home
- Gen X and Boomers make up the majority of the customer base and account for the highest share of total spend
- Spain is the largest market by volume but Mexico and Canada have higher average spend per customer

**Products**
- Wine accounts for 50% of total revenue — the clear hero product
- Meat is a distant second at 27%
- Fruits, sweets, and fish together account for less than 15% of total spend

**Channels**
- In-store is the dominant purchase channel across all generations
- Web is a strong secondary channel, especially for Gen X
- Catalog performs consistently but below store and web

**Campaigns**
- The latest campaign had the highest response rate by far — 325 acceptances vs an average of 150 for campaigns 1–5
- Campaign 2 had the lowest response rate at just 30 — significantly underperformed

---

## Customer Targeting Funnel

Starting from 2,193 total customers, we identified a high-value target segment of ~550 customers using sequential filtering:

| Stage | Criteria | Customers |
|-------|----------|-----------|
| 1 | All customers | 2,193 |
| 2 | Income $50K–$100K | ~1,100 |
| 3 | + Gen X & Boomers | ~970 |
| 4 | + 0–1 dependents | ~820 |
| 5 | + Married/Together | ~550 |

---

## Recommendations

**1. Double down on wine and meat**
These two products represent 77% of total revenue. All campaigns should lead with wine and meat, especially for the target segment.

**2. Prioritize in-store, support with web**
Both Boomers and Gen X prefer in-store purchases. Invest in in-store merchandising and signage. Use web as a secondary activation channel, particularly for Gen X.

**3. Replicate the latest campaign**
The most recent campaign drove 2x the responses of any previous campaign. Understand what made it different and build the next campaign on that framework.

**4. Campaign Framework for the ~550 target segment**

| Campaign | Target | Concept |
|----------|--------|---------|
| 1 — Loyalty, Boomers | High spend Boomers | Free bottle of wine with next purchase over $600 |
| 2 — Loyalty, Gen X | High spend Gen X | 20% off when you spend $600+ |
| 3 — Reactivation, Boomers | Low recency Boomers | Buy 2 bottles of wine get 1 free |
| 4 — Reactivation, Gen X | Low recency Gen X | 20% off your next in-store purchase |

---

## Files

- `data_cleaning.sql` — duplicate removal, standardization, data type conversion
- `eda.sql` — customer profiling, product analysis, channel analysis, campaign performance

---

## Process

1. Imported raw CSV into MySQL using Node.js import script
2. Created staging tables to preserve raw data
3. Removed 47 duplicate rows using ROW_NUMBER() window function
4. Standardized Marital_Status (removed Absurd, YOLO, merged Alone into Single)
5. Converted date columns and numeric columns to proper data types
6. Performed EDA across customer, product, channel, and campaign dimensions
7. Built Tableau dashboards — analysis overview and targeting recommendation
