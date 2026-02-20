# Layoffs Analysis

## Project Overview

This project analyzes a dataset of company layoffs from 2022 onwards, sourced from [Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022). The project is split into two parts:

1. **Data Cleaning** - Preparing the raw data for analysis
2. **Exploratory Data Analysis** - Drawing insights from the cleaned data *(coming soon)*

## Dataset

The dataset contains information about company layoffs including company name, location, industry, number of employees laid off, percentage laid off, date, company stage, country, and funds raised.

## Part 1: Data Cleaning

The data cleaning process followed four steps:

**1. Remove Duplicates** — Used `ROW_NUMBER()` with `PARTITION BY` across all columns to identify and remove exact duplicate rows.

**2. Standardize Data** — Fixed several inconsistencies:
- Filled in missing industry values using a self join where other rows for the same company had the industry populated
- Standardized Crypto industry naming variations (Crypto Currency, CryptoCurrency → Crypto)
- Removed trailing periods from country names (United States. → United States)
- Converted the date column from text to proper DATE format

**3. Handle Null Values** — Left nulls in numeric columns (total_laid_off, percentage_laid_off, funds_raised_millions) as they are, since nulls are more useful than placeholder zeros during analysis.

**4. Remove Unnecessary Rows and Columns** — Deleted rows where both `total_laid_off` and `percentage_laid_off` were null, as these records contain no useful layoff information. Dropped the helper `row_num` column after it served its purpose.

## Files

- `data_cleaning.sql` — Full data cleaning script with comments
- `exploratory_analysis.sql` — EDA queries *(coming soon)*

## Tools Used

- MySQL
- MySQL Workbench
