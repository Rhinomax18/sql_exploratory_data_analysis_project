-- Data Exploration:-

-- Find the date of the first and last order

SELECT MIN(order_date) AS fisrt_OrderDate, 
	   MAX(order_date) AS last_OrderDate ,
	   DATEDIFF(YYYY, MIN(order_date), MAX(order_date)) AS Range_YY,
	   DATEDIFF(MM, MIN(order_date), MAX(order_date)) AS Range_MM
FROM gold.fact_sales

-- Find the youngest and the oldest customers in the database

SELECT
		MAX(birthdate) AS youngest_cst,
		DATEDIFF(YYYY, MAX(birthdate),GETDATE()) AS Youngest_Age,
		MIN(birthdate) AS oldest_cst,
		DATEDIFF(YYYY, MIN(birthdate),GETDATE()) AS Oldest_Age
FROM gold.dim_customers