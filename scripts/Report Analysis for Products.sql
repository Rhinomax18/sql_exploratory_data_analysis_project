-- Reporting Analysis (Products)

CREATE VIEW Report_Products AS
WITH cte AS
(
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
SELECT
    f.order_number,
    f.order_date,
    f.customer_key,
    f.sales_amount,
    f.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
)
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
, Product_Aggregation AS
(
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    MAX(order_date) last_sale_date,
    COUNT(DISTINCT order_number) Total_Orders,
    COUNT(DISTINCT customer_key) Total_Customers,
    SUM(cost) Total_Sales,
    SUM(quantity) Total_Quantity,
    DATEDIFF(mm,MIN(ORDER_DATE),MAX(ORDER_DATE)) Lifespan,
    ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM cte
GROUP BY product_key,
         product_name,
         category,
         subcategory,
         cost
)

SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(mm,last_sale_date,GETDATE()) Revency,
    -- Average Order Revenue (AOR)
    CASE WHEN Total_Sales > 50000 THEN 'High-Performance'
         WHEN Total_Sales >= 10000 THEN 'Medium-Performance'
         ELSE 'Low Performance'
    END product_segment,
    -- Average Monthly Revenue
    CASE WHEN Lifespan = 0 THEN Total_Sales
         ELSE Total_Sales / Lifespan
    END Avg_monthly_revenue
FROM Product_Aggregation


SELECT
    p.product_key,
    p.product_name,
    COUNT(p.product_key) Total_Products,
    COUNT(f.order_number) Total_Orders,
    COUNT(f.customer_key) Total_customers,
    SUM(f.sales_amount)
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_key, p.product_name
ORDER BY p.product_key

SELECT
    p.product_key,
    p.product_name,
    f.sales_amount
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key

WHERE product_name = 'Mountain'
