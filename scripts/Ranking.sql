-- Ranking:-

-- Which 5 products generate the highest revenue?
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS Total_Revenue
FROM Gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue DESC


-- Which are the 5 worst-performing products in terms of sales?
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS Total_Revenue
FROM Gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue 


-- Now by WINDOW FUNCTIONS:-
-- Which 5 products generate the highest revenue?
SELECT * FROM 
(
SELECT 
	RANK() OVER(ORDER BY SUM(f.sales_amount) DESC) AS Ranking_Products,
	p.product_name,
	SUM(f.sales_amount) AS Total_Revenue
FROM Gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
)t
WHERE Ranking_Products <= 5


-- Find the TOP-10 customers who have generated the highest revenue.
SELECT TOP 10
	c.customer_id,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS Total_Revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_id,
	c.first_name,
	c.last_name
ORDER BY Total_Revenue DESC

-- Find 3 customers with the fewest orders placed.
SELECT TOP 3
	c.customer_id,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT f.order_number) AS Total_Orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_id,
	c.first_name,
	c.last_name

ORDER BY Total_Orders
