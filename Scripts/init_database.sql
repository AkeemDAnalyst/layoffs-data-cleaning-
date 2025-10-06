CREATE DATABASE Layoff
GO
USE Layoff
GO
SELECT * FROM layoffs

-- CREATE SCHEMA
CREATE SCHEMA stg

-- Insert raw data inot the schema 
SELECT * INTO stg.Layoff FROM layoffs


/*===========================================================================================================

						DATA CLEANING AND FEATURE ENGINEERING
============================================================================================================*/
SELECT * FROM stg.Layoff


-- Standardlize tect
SELECT 
	UPPER(TRIM(Company)) AS Company,
	UPPER(TRIM(	Location)) AS Location,
	UPPER(TRIM(industry)) AS industry,
	UPPER(TRIM(Stage)) AS Stage,
	UPPER(TRIM(country)) AS Ccountry
FROM stg.Layoff

-- Data type
SELECT 
	CAST( date_added AS DATE ) AS date_added
	FROM stg.Layoff

-- feature Engineering 
SELECT 
	YEAR(date_added) AS YEAR_date_added,
	MONTH(date_added) AS MONTH_date_added,
	DAY(date_added) AS DAY_date_added
FROM stg.Layoff

-- Remove duplicate 
WITH CTE AS (
SELECT 
	*,
	ROW_NUMBER() OVER( PARTITION BY Company, Location, industry, Stage, country, total_laid_off, percentage_laid_off,
	source, funds_raised ORDER BY date_added) AS Row_nm
FROM stg.Layoff
)
SELECT * FROM CTE
WHERE Row_nm = 1

/*======================================================================================================
                     HANDLE NULL
========================================================================================================*/
-- For the categorical
SELECT 
	COALESCE(Company, 'Unknown') AS Company,
	COALESCE(Location,'Unknown') AS Location,
	COALESCE(industry, 'Unknown') AS industry,
	COALESCE(Stage, 'Unknown') AS Stage,
	COALESCE(country, 'Unknown') AS Ccountry
FROM stg.Layoff


/*======================================================================================================
                -- For the numeric
========================================================================================================*/
--Find % missing for key columns 
SELECT 
	COUNT(*),
	SUM( CASE WHEN total_laid_off IS NULL THEN 1 ELSE 0 END) * 1.0/COUNT(*) AS total_laid_off_Missing,
	SUM( CASE WHEN percentage_laid_off IS NULL THEN 1 ELSE 0 END) * 1.0/COUNT(*) AS percentage_laid_off_Missing,
	SUM( CASE WHEN funds_raised IS NULL THEN 1 ELSE 0 END) * 1.0/COUNT(*) AS funds_raised_Missing
FROM stg.Layoff

--Check distribution (to see median & outliers) For total_laid_off
WITH MED AS (
SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP ( ORDER BY total_laid_off) OVER () AS Med_total_laid_off
FROM stg.Layoff
) 
SELECT * FROM MED
WHERE Med_total_laid_off IS NOT NULL


-- Check distribution (to see median & outliers) For  percentage_laid_off
WITH CLEAN AS (
SELECT 
	TRY_CAST(REPLACE( percentage_laid_off, '%', '') AS decimal(10,2)) AS Pct_num
FROM STG.Layoff
),
MED AS (
	SELECT
		PERCENTILE_CONT(0.5) WITHIN GROUP ( ORDER BY Pct_num) OVER () AS Med_Pct
FROM CLEAN
)
SELECT * FROM CLEAN


-- Check distribution (to see median & outliers) For funds_raised
WITH MED AS (
SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP ( ORDER BY funds_raised) OVER () AS Med_funds_raised
FROM stg.Layoff
) 
SELECT * FROM MED
WHERE Med_funds_raised IS NOT NULL
/*=================================================================================
-- CREATE VIEW 
=====================================================================================*/
CREATE VIEW VW_LAYOFF AS 
WITH CLEAN AS (
SELECT *,
	TRY_CAST(REPLACE( percentage_laid_off, '%', '') AS decimal(10,2)) AS Pct_num,
	ROW_NUMBER() OVER( PARTITION BY Company, Location, industry, Stage, country, total_laid_off, percentage_laid_off,
	source, funds_raised ORDER BY date_added) AS Row_nm
FROM stg.Layoff
),
MED AS (
	SELECT
		PERCENTILE_CONT(0.5) WITHIN GROUP ( ORDER BY total_laid_off) OVER () AS Med_total_laid_off,
		PERCENTILE_CONT(0.5) WITHIN GROUP ( ORDER BY funds_raised) OVER () AS Med_funds_raised,
		PERCENTILE_CONT(0.5) WITHIN GROUP ( ORDER BY Pct_num) OVER () AS Med_Pct
FROM CLEAN
)
SELECT  
	COALESCE(UPPER(TRIM(Company)), 'Unknown') AS Company,
	COALESCE(UPPER(TRIM(Location)),'Unknown') AS Location,
	COALESCE(UPPER(TRIM(industry)), 'Unknown') AS industry,
	COALESCE(UPPER(TRIM(Stage)), 'Unknown') AS Stage,
	COALESCE(UPPER(TRIM(country)), 'Unknown') AS Ccountry,
	YEAR(date_added) AS YEAR_date_added,
	MONTH(date_added) AS MONTH_date_added,
	DAY(date_added) AS DAY_date_added,
	CASE WHEN total_laid_off IS NULL THEN 1 ELSE 0 END AS total_laid_off_Missing,
	CASE WHEN total_laid_off IS NULL THEN 1 ELSE 0 END AS percentage_laid_off_Missing ,
	CASE WHEN funds_raised IS NULL THEN 1 ELSE 0 END AS funds_raised_Missing,
	COALESCE( total_laid_off, (SELECT TOP 1 Med_total_laid_off FROM MED)) AS imp_total_laid_off,
	COALESCE( total_laid_off, (SELECT TOP 1 Med_Pct FROM MED)) AS imp_percentage_laid_off,
	COALESCE( funds_raised, (SELECT TOP 1 Med_funds_raised FROM MED)) AS imp_funds_raised
FROM CLEAN
WHERE Row_nm = 1

SELECT * FROM VW_Layoff
