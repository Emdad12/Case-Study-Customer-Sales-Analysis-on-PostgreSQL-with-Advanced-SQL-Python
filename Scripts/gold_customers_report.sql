/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
DROP VIEW IF EXISTS gold_report_customers;

CREATE VIEW gold_report_customers AS

(

WITH base_query AS (
--Base query :Retrieve core columns from tables
SELECT 
f.product_key,
f.order_number,
f.quantity,
f.sales_amount,
f.order_date,
c.customer_key,
c.first_name||' '||c.last_name AS customer_full_name,
c.customer_number,
EXTRACT(year FROM AGE(NOW()::Date,c.birthdate)) AS Age
FROM gold_fact_sales AS f
LEFT JOIN gold_dim_customers AS c
ON f.customer_key=c.customer_key
WHERE f.order_date IS NOT NULL)


,customer_aggregation AS(
SELECT 
		customer_key,
		customer_number,
		customer_full_name,
		Age,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT order_number) AS total_orders,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		EXTRACT(year FROM AGE(MAX(order_date),MIN(order_date)))*12
		+
		EXTRACT(month FROM AGE(MAX(order_date),MIN(order_date))) AS life_span
FROM base_query
GROUP BY customer_key,
		 customer_number,
		 customer_full_name,
		 Age )

SELECT 
		customer_key,
		customer_number,
		customer_full_name,
		age,
		CASE 
			 WHEN age < 20 THEN 'Under 20'
			 WHEN age between 20 and 29 THEN '20-29'
			 WHEN age between 30 and 39 THEN '30-39'
			 WHEN age between 40 and 49 THEN '40-49'
			 ELSE '50 and above'
		END AS age_group,
		total_sales,
		CASE WHEN life_span>=12 AND total_sales>5000 THEN 'VIP'
			 WHEN life_span>=12 AND total_sales<=5000 THEN 'Regular'
			 ELSE 'New' END AS status,
		total_quantity,
		total_orders,
		total_products,
		last_order_date,
		life_span,
		AGE(NOW()::Date,last_order_date) AS recency,
		CASE WHEN total_orders<=0 THEN 0
			 ELSE total_sales/total_orders
			 END AS avg_order_value,
		CASE WHEN life_span<=0 THEN 0
			 ELSE ROUND(total_sales/life_span,0)
			 END AS monthly_spend
FROM customer_aggregation );

















