USE DataWarehouseAnalytics

-- Explore All Obejects in the database

SELECT * FROM INFORMATION_SCHEMA.TABLES 

-- Explore All Columns in the Database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE Table_name = 'dim_products'