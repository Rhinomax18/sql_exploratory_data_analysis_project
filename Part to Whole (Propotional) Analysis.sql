-- Which Category contribute the most to overall sales?
WITH cte as
(
SELECT
	p.category,
	SUM(f.sales_amount) Total_Sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.category
)
SELECT
category,
Total_Sales,
SUM(Total_Sales) OVER() Overall_Sales,
ROUND(CAST(Total_Sales AS float) * 100 / SUM(Total_Sales) OVER() , 2) [% Total]
FROM cte
ORDER BY [% Total] DESC

-- Which Category contribute the most to overall customers?

WITH Cte2 AS
(
SELECT
	p.category,
	COUNT(f.customer_key) Total_Customers_by_Category
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.category
)
SELECT
	category,
	Total_Customers_by_Category,
	SUM(Total_Customers_by_Category) OVER() Total_Customers ,
	ROUND(CAST(Total_Customers_by_Category AS float) * 100 / SUM(Total_Customers_by_Category) OVER() , 2) [% Total]
FROM Cte2
ORDER BY [% Total] DESC