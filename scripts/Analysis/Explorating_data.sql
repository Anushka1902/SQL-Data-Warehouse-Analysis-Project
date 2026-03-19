--DATABASE EXPLORATION
/* Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
    */
use DataWarehouse;
-- Explore all objects in the database
select * from INFORMATION_SCHEMA.TABLES
--Explore all columns in the database
select * from INFORMATION_SCHEMA.COLUMNS;

--DIMENSION EXPLORATION
/*Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
 */
-- Explore all countries our customers come from
select distinct country from gold.dim_customers;
--explore all Categories 'The major Divisions'
select distinct category, subcategory, product_name from gold.dim_products
order by 1,2,3;

-- DATE EXPLORATION
/* Identify the earliest and lates dates(boundaries)
	Understand the scope of data and the timespan.
	MIN/MAX Function
    Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.
SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
 */

--find the first and last order date
-- find how many year of sales are available
select 
min(order_date) as first_order_date,
max(order_date) as last_order_date,
datediff(year,min(order_date),max(order_date)) as order_range_in_years
from gold.fact_sales;

-- find the youngest and oldest customer
select min(birthdate) as oldest_birthdate,
datediff(year,min(birthdate),GETDATE()) as oldest_age,
max(birthdate) as youngest_birthdate
from gold.dim_customers;

--MEASURES EXPLORATION
/* TO CALCULATE THE KEY METRICS OF OUR DATA
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.
SQL Functions Used:
    - COUNT(), SUM(), AVG()
 */
 -- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
