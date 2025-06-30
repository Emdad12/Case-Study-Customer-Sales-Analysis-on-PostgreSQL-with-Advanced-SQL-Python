# Case-Study-Customer-Sales-Analysis-on-PostgreSQL-with-Advanced-SQL-Python
🧩 Objective
The goal of this case study is to analyze sales, product, and customer data to extract valuable business insights. This involves loading raw data into a PostgreSQL database, designing relational schemas, and using advanced SQL techniques (CTEs, joins, window functions, subqueries) to answer real-world business questions.  

### 📂 Data Sources
The project uses three datasets:

Dataset	Description
gold_dim_product:	Product ID, category, pricing info....
gold_dim_customer	:Customer demographics and details
gold_fact_sales:	Transactional sales data (fact table)
Data is initially in .csv format and loaded into PostgreSQL using Python (via psycopg2).

### 🛠️ Tools & Technologies
PostgreSQL: For creating tables and performing analysis using SQL.

pgAdmin: For visualizing and managing the PostgreSQL database.

Python: For connecting to the database and automating ETL processes.

pandas: For reading CSV files and optional data manipulation.

Jupyter Notebook: For writing and presenting analysis (optional).

### 🔁 Workflow Summary
***Data Import (Python)***

- Read the CSV files using pandas

- Create a database and connect via psycopg2

- Create and populate tables in PostgreSQL

***Data Modeling***

- gold_fact_sales as the fact table

- gold_dim_product and gold_dim_customer as dimension tables

- Relationships: Many sales → One product; Many sales → One customer

***Data Analysis (SQL in pgAdmin)***

- Joined tables for complete context

- Created reusable Common Table Expressions (CTEs)

- Used subqueries and window functions for deeper insights

## 🧠 SQL Concepts Applied
✅ SELECT, GROUP BY, WHERE, ORDER BY

✅ JOINs (INNER, LEFT)

✅ Subqueries

✅ Common Table Expressions (CTEs)

✅ Window Functions (ROW_NUMBER, RANK,LAG(),AVG() OVER(), SUM OVER, etc.)

✅ Filtering with HAVING

✅ Aggregates (SUM, AVG, COUNT, MAX, MIN)

## 🧠 Key Metrics & Insights Extracted

### 📊 Business KPIs
- Total Sales, Items Sold, Number of Orders, Customers, and Products
- Average Selling Price
- Total Revenue by Product Category and Country

### 👤 Customer Insights
- Customer distribution by country and gender
- Top 10 customers by total revenue
- Customer segmentation based on lifespan and spend (VIP, Regular, New)

### 📦 Product Insights
- Top 5 and bottom 5 products by revenue
- Average cost by category
- Product cost segmentation

### 📈 Time-based Trends
- Sales trends by month and year
- Running totals of monthly revenue
- Year-over-year product performance comparisons
## SQL queries
You can find the all query in the sql script which is located in script folder
### Example queries
- **1.How many sales of year are availabe**
  ```sql
  SELECT 
		Extract( year from AGE(MAX(order_date),
		MIN(order_date))) AS length_year
FROM gold_fact_sales; ```
**Output**:
"length_year"
3
- **2.find the youngest and oldest customer**
```sql
WITH cte AS(
  SELECT 
    (first_name || ' ' || last_name) AS name, 
    AGE(NOW() :: Date, birthdate) AS age 
  FROM 
    gold_dim_customers
) 
SELECT 
  name, 
  'youngest_customer' AS conditions, 
  age 
FROM 
  cte 
WHERE 
  age =(
    SELECT 
      MIN(age) 
    FROM 
      cte
  ) 
UNION 
SELECT 
  name, 
  'oldest_customer' AS conditions, 
  age 
FROM 
  cte 
WHERE 
  age =(
    SELECT 
      MAX(age) 
    FROM 
      cte
  );
```
  
**Output**:
|name           |conditions       |age                     |
|---------------|-----------------|------------------------|
|Gabrielle James|oldest_customer  |109 years 4 mons 20 days|
|Logan Anderson |youngest_customer|39 years 5 days         |
|Roger Rai      |youngest_customer|39 years 5 days         |

- **Generate a reports that shows all key metrics of the business**
  ```sql
  WITH metrics AS(
  SELECT 
    'Total_sales' AS measure_name, 
    SUM(sales_amount) AS measure_value 
  FROM 
    gold_fact_sales 
  UNION 
  SELECT 
    'Total_item_Sales' AS measure_name, 
    SUM(quantity) AS measure_value 
  FROM 
    gold_fact_sales 
  UNION 
  SELECT 
    'average_selling_price' AS measure_name, 
    ROUND(
      AVG(price), 
      2
    ) AS measure_value 
  FROM 
    gold_fact_sales 
  UNION 
  SELECT 
    ' Total orders' AS measure_name, 
    COUNT(DISTINCT order_number) AS measure_value 
  FROM 
    gold_fact_sales 
  UNION 
  SELECT 
    ' Total customers' AS measure_name, 
    COUNT(DISTINCT customer_key) AS measure_value 
  FROM 
    gold_dim_customers 
  UNION 
  SELECT 
    ' Total products' AS measure_name, 
    COUNT(DISTINCT product_key) AS measure_value 
  FROM 
    gold_dim_products 
  UNION 
  SELECT 
    'total_ordered_customers' AS measure_name, 
    COUNT(DISTINCT customer_key) 
  FROM 
    gold_fact_sales 
  WHERE 
    order_number IS NOT NULL
  ) 
 SELECT 
  * 
 FROM 
  metrics;
  
**Output**:
|measure_name   |measure_value    |
|---------------|-----------------|
| Total customers|18484            |
| Total orders  |27659            |
| Total products|295              |
|average_selling_price|486.04           |
|Total_item_Sales|60423            |
|total_ordered_customers|18484            |
|Total_sales    |29356250         |

  
  


