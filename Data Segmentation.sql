-- Data Segmentation

-- Segment products into cost ranges and 
-- count how many products fall into each segment.



WITH cte AS 
(
SELECT
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		 ELSE 'Above 1000'
	END cost_range	 
FROM gold.dim_products
)
SELECT
	cost_range,
	COUNT(product_key) Total_Products
FROM cte
GROUP BY cost_range
ORDER BY Total_Products DESC


/*
Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/


WITH customer_spending AS
(
SELECT
	c.customer_key,
	SUM(f.sales_amount) Total_Spending,
	MIN(order_date) fisrt_order,
	MAX(order_date) last_order,
	DATEDIFF(mm,MIN(order_date),MAX(Order_date)) Lifespan
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales f
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT
	customer_key,
	Total_Spending,
	Lifespan,
	CASE WHEN Lifespan > 12 AND Total_Spending > 5000 THEN 'VIP'
		 WHEN Lifespan >= 12 AND Total_Spending <= 5000 THEN 'Regular'
		 WHEN Lifespan < 12 THEN 'New'
		 END customer_Segment
FROM customer_spending



-- Now for the total customers by each group.

WITH customer_spending AS
(
SELECT
	c.customer_key,
	SUM(f.sales_amount) Total_Spending,
	MIN(order_date) fisrt_order,
	MAX(order_date) last_order,
	DATEDIFF(mm,MIN(order_date),MAX(Order_date)) Lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
	customer_Segment,
	COUNT(customer_key) Total_Customers
FROM (
SELECT
	customer_key,
	CASE WHEN Lifespan >= 12 AND Total_Spending > 5000 THEN 'VIP'
		 WHEN Lifespan >= 12 AND Total_Spending <= 5000 THEN 'Regular'
		 ELSE 'New'
		 END customer_Segment
FROM customer_spending
)y
GROUP BY customer_Segment
ORDER BY Total_Customers DESC