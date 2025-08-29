-- Cumulative Data Analysis

-- Calculate the total sales per month. 
-- Running total of sales over time.

SELECT
Order_Date,
Total_Sales,
SUM(Total_Sales) OVER( ORDER BY Order_Date) Running_Total_Sales,
AVG(Avg_Price) OVER( ORDER BY Order_Date) Moving_Average_Price
FROM
(
SELECT
	DATETRUNC(mm,Order_Date) Order_Date,
	SUM(Sales_Amount)  Total_Sales,
	AVG(Price) Avg_Price
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY DATETRUNC(mm,Order_Date)
)t

-- Calculate the total sales per Year. 
-- Running total of sales over time.

SELECT
Order_Date,
Total_Sales,
SUM(Total_Sales) OVER( ORDER BY Order_Date) Running_Total_Sales,
AVG(Avg_Price) OVER( ORDER BY Order_Date) Moving_Average_Price
FROM
(
SELECT
	DATETRUNC(YYYY,Order_Date) Order_Date,
	SUM(Sales_Amount)  Total_Sales,
	AVG(Price) Avg_Price
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY DATETRUNC(yyyy,Order_Date)
)t




-- By YEAR.
SELECT
	Order_Year,
	Total_Sales,
	SUM(Total_Sales) OVER(ORDER BY Order_year) Running_Total
FROM
(
SELECT
	YEAR(Order_Date) Order_Year,
	SUM(Sales_Amount) Total_Sales
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY YEAR(Order_Date)
)y