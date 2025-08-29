-- Performance Analysis

-- Analyze the yaerly performannce of products by 
-- comparing each product's sales of both its average sales 
-- performance and the previous year's sales.

WITH cte AS
(
SELECT
	YEAR(f.Order_Date) Order_Year,
	p.Product_Name,
	SUM(f.Sales_Amount) Current_Sales
FROM gold.Fact_Sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date is not null
GROUP BY YEAR(order_date), p.product_name
)
SELECT
	Order_Year,
	product_name,
	Current_Sales,
	AVG(Current_Sales) OVER(PARTITION BY Product_name) Avg_Sales,
	Current_Sales - AVG(Current_Sales) OVER(PARTITION BY Product_name) Diff_Avg,
	CASE WHEN Current_Sales - AVG(Current_Sales) OVER(PARTITION BY Product_name) > 0 then 'Above Avg'
		 WHEN Current_Sales - AVG(Current_Sales) OVER(PARTITION BY Product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END Avg_Change,
	-- Year-Over-Year (YoY) Analysis
	LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) PY_Sales,
	Current_Sales - LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) Diff_PY,
	CASE WHEN Current_Sales - LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) > 0 then 'Increase'
		 WHEN Current_Sales - LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END PY_Change
FROM cte
ORDER BY product_name, Order_Year

