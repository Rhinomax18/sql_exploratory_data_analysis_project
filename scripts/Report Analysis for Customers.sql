-- Reporting Analysis 

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
CREATE VIEW gold.Report_Customers AS
WITH cte AS
(
-- Basic Essential Fields.
SELECT
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) Customer_Name,
	DATEDIFF(YYYY,c.birthdate,GETDATE()) Age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE order_date IS NOT NULL
)
, Customer_Aggregation AS
-- Aggregation Customer-Level
(
SELECT
	customer_key,
	customer_number,
	Customer_Name,
	age,
	COUNT(DISTINCT order_number) Total_Orders,
	SUM(sales_amount) Total_Sales,
	SUM(quantity) Total_Quantity,
	COUNT(DISTINCT product_key) Total_Products,
	MAX(order_date) Last_order_date,
	DATEDIFF(mm,min(order_date),max(order_date)) Lifespan
FROM cte
GROUP BY customer_key,
		 customer_number,
		 Customer_Name,
		 age
)
SELECT
	customer_key,
	customer_number,
	Customer_Name,
	age,
	-- Segments of customers
	CASE WHEN age < 20 THEN 'under 20'
		 WHEN age BETWEEN 20 AND 29 THEN '20-29'
		 WHEN age BETWEEN 30 AND 39 THEN '30-39'
		 WHEN age BETWEEN 40 AND 49 THEN '40-49'
		 ELSE '50 Above'
	END age_group,
	CASE WHEN Lifespan >= 12 AND Total_Sales > 5000 THEN 'VIP'
		 WHEN Lifespan >= 12 AND Total_Sales <= 5000 THEN 'Regular'
		 ELSE 'New'
	END customer_segment,
	DATEDIFF(mm,Last_order_date,GETDATE()) Recency,
	Total_Orders,
	Total_Sales,
	Total_Quantity,
	Total_Products,
	Last_order_date,
	Lifespan,
	-- Compute average order value (AOV)
	CASE WHEN Total_Orders = 0 THEN 0
	ELSE Total_Sales / Total_Orders 
	END Avg_Order_Value,
	-- Compute average monthly spend
	CASE WHEN Lifespan = 0 THEN Total_Sales
	ELSE Total_Sales / Lifespan
	END Avg_Monthly_Spend

FROM Customer_Aggregation
