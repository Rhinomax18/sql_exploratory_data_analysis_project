-- Measure Exploration:-

-- Find the Total Sales
SELECT SUM(sales_amount) Total_Sales
FROM gold.fact_sales

-- Find the total items are sold.
SELECT  SUM(quantity) Item_Sold
FROM gold.fact_sales

-- Find the average selling prince
SELECT AVG(sales_amount) Avg_Sales
FROM gold.fact_sales

-- Find the total no. of orders
SELECT COUNT(order_number) AS Total_Orders 
FROM gold.fact_sales
/* Using the DISTINCT helps you to remove duplicates from the column because 
   sometimes in a single order no. the are multiple items ordered by the customer. */
SELECT COUNT(DISTINCT order_number) AS Total_Orders 
FROM gold.fact_sales

-- Find the total no. of products
SELECT COUNT(product_id) AS Total_Products 
FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(DISTINCT customer_id) AS Total_Customers
from gold.dim_customers

-- Find the total Customers that has placed an order.
SELECT COUNT( customer_key) AS Total_Customers
FROM gold.fact_sales


-- Generate a Report that shows all keys metrics of the business

SELECT 'Total Sales' AS Measure_Name,SUM(sales_amount) Measure_Value
FROM gold.fact_sales
UNION ALL
SELECT  'Item_Sold',SUM(quantity) 
FROM gold.fact_sales
UNION ALL
SELECT 'Avg_Sales',AVG(sales_amount) 
FROM gold.fact_sales
UNION ALL
SELECT 'Total_Orders' ,COUNT(DISTINCT order_number)  
FROM gold.fact_sales
UNION ALL
SELECT 'Total_Products' ,COUNT(product_id) 
FROM gold.dim_products
UNION ALL
SELECT 'Total No. Customers' ,COUNT( customer_key)  
FROM gold.fact_sales