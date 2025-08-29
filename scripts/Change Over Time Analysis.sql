-- Analyze Sales Performance Over Time.
SELECT
	YEAR(Order_Date) Order_Year,
	SUM(Sales_Amount) Total_Sales,
	COUNT(DISTINCT customer_key) Total_Customers,
	SUM(Quantity) Total_Quantity
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY YEAR(Order_Date)
ORDER BY Order_Year


SELECT
	MONTH(Order_Date) Order_Month,
	SUM(Sales_Amount) Total_Sales,
	COUNT(DISTINCT customer_key) Total_Customers,
	SUM(Quantity) Total_Quantity
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY MONTH(Order_Date)
ORDER BY Order_Month


SELECT
	DATETRUNC(MONTH,order_date) Order_Date,
	SUM(Sales_Amount) Total_Sales,
	COUNT(DISTINCT customer_key) Total_Customers,
	SUM(Quantity) Total_Quantity
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
ORDER BY Order_Date

