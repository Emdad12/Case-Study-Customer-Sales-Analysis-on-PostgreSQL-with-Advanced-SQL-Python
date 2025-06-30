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

- **find the total sales over time**
```sql
SELECT 
  EXTRACT(
    year 
    FROM 
      order_date
  ) AS year, 
  EXTRACT(
    month 
    FROM 
      order_date
  ) AS month, 
  SUM(sales_amount) AS total_sales, 
  COUNT(DISTINCT customer_key) AS total_customer, 
  SUM(quantity) AS total_quantity 
FROM 
  gold_fact_sales 
WHERE 
  order_date IS NOT NULL 
GROUP BY 
  EXTRACT(
    year 
    FROM 
      order_date
  ), 
  EXTRACT(
    month 
    FROM 
      order_date
  ) 
ORDER BY 
  year, 
  month;
```
**Output**
|year|month|total_sales|total_customer|total_quantity|
|----|-----|-----------|--------------|--------------|
|2010|12   |43419      |14            |14            |
|2011|1    |469795     |144           |144           |
|2011|2    |466307     |144           |144           |
|2011|3    |485165     |150           |150           |
|2011|4    |502042     |157           |157           |
|2011|5    |561647     |174           |174           |
|2011|6    |737793     |230           |230           |
|2011|7    |596710     |188           |188           |
|2011|8    |614516     |193           |193           |
|2011|9    |603047     |185           |185           |
|2011|10   |708164     |221           |221           |
|2011|11   |660507     |208           |208           |
|2011|12   |669395     |222           |222           |
|2012|1    |495363     |252           |252           |
|2012|2    |506992     |260           |260           |

- **Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales**
```sql
WITH yearly_product_sales AS (
  SELECT 
    EXTRACT(
      year 
      FROM 
        f.order_date
    ) AS order_year, 
    p.product_name, 
    SUM(f.sales_amount) AS Current_sales 
  FROM 
    gold_fact_sales AS f 
    LEFT JOIN gold_dim_products AS p ON f.product_key = p.product_key 
  GROUP BY 
    EXTRACT(
      year 
      FROM 
        f.order_date
    ), 
    p.product_name 
  ORDER BY 
    order_year
) 
SELECT 
  order_year, 
  product_name, 
  current_sales, 
  ROUND(
    AVG(current_sales) OVER(PARTITION BY product_name), 
    2
  ) AS avg_sales, 
  ROUND(
    current_sales - AVG(current_sales) OVER(PARTITION BY product_name), 
    2
  ) AS avg_diff, 
  CASE WHEN (
    current_sales - AVG(current_sales) OVER(PARTITION BY product_name)
  )> 0 THEN 'Above average' WHEN (
    current_sales - AVG(current_sales) OVER(PARTITION BY product_name)
  )< 0 THEN 'Below average' ELSE 'Equal' END AS diff_avg, 
  LAG(current_sales, 1) OVER(
    PARTITION BY product_name 
    ORDER BY 
      order_year
  ) AS py_sales, 
  current_sales - LAG(current_sales, 1) OVER(
    PARTITION BY product_name 
    ORDER BY 
      order_year
  ) AS diff_py, 
  CASE WHEN current_sales - LAG(current_sales, 1) OVER(
    PARTITION BY product_name 
    ORDER BY 
      order_year
  )> 0 THEN 'Increased' WHEN current_sales - LAG(current_sales, 1) OVER(
    PARTITION BY product_name 
    ORDER BY 
      order_year
  )< 0 THEN 'Decreased' ELSE 'No Change' END AS py_diff 
FROM 
  yearly_product_sales 
ORDER BY 
  product_name, 
  order_year
```

**Output**
|order_year|product_name                   |current_sales|avg_sales|avg_diff  |diff_avg     |py_sales|diff_py|py_diff  |
|----------|-------------------------------|-------------|---------|----------|-------------|--------|-------|---------|
|2012      |All-Purpose Bike Stand         |159          |13197.00 |-13038.00 |Below average|NULL    |NULL   |No Change|
|2013      |All-Purpose Bike Stand         |37683        |13197.00 |24486.00  |Above average|159     |37524  |Increased|
|2014      |All-Purpose Bike Stand         |1749         |13197.00 |-11448.00 |Below average|37683   |-35934 |Decreased|
|2012      |AWC Logo Cap                   |72           |6570.00  |-6498.00  |Below average|NULL    |NULL   |No Change|
|2013      |AWC Logo Cap                   |18891        |6570.00  |12321.00  |Above average|72      |18819  |Increased|
|2014      |AWC Logo Cap                   |747          |6570.00  |-5823.00  |Below average|18891   |-18144 |Decreased|
|2013      |Bike Wash - Dissolver          |6960         |3636.00  |3324.00   |Above average|NULL    |NULL   |No Change|
|2014      |Bike Wash - Dissolver          |312          |3636.00  |-3324.00  |Below average|6960    |-6648  |Decreased|
|2013      |Classic Vest- L                |11968        |6240.00  |5728.00   |Above average|NULL    |NULL   |No Change|
|2014      |Classic Vest- L                |512          |6240.00  |-5728.00  |Below average|11968   |-11456 |Decreased|
|2013      |Classic Vest- M                |11840        |6368.00  |5472.00   |Above average|NULL    |NULL   |No Change|
|2014      |Classic Vest- M                |896          |6368.00  |-5472.00  |Below average|11840   |-10944 |Decreased|
|2012      |Classic Vest- S                |64           |3648.00  |-3584.00  |Below average|NULL    |NULL   |No Change|
|2013      |Classic Vest- S                |10368        |3648.00  |6720.00   |Above average|64      |10304  |Increased|
|2014      |Classic Vest- S                |512          |3648.00  |-3136.00  |Below average|10368   |-9856  |Decreased|
|2012      |Fender Set - Mountain          |110          |15554.00 |-15444.00 |Below average|NULL    |NULL   |No Change|
|2013      |Fender Set - Mountain          |44484        |15554.00 |28930.00  |Above average|110     |44374  |Increased|
|2014      |Fender Set - Mountain          |2068         |15554.00 |-13486.00 |Below average|44484   |-42416 |Decreased|
|2012      |Half-Finger Gloves- L          |24           |3544.00  |-3520.00  |Below average|NULL    |NULL   |No Change|
|2013      |Half-Finger Gloves- L          |10248        |3544.00  |6704.00   |Above average|24      |10224  |Increased|
|2014      |Half-Finger Gloves- L          |360          |3544.00  |-3184.00  |Below average|10248   |-9888  |Decreased|
|2012      |Half-Finger Gloves- M          |24           |3992.00  |-3968.00  |Below average|NULL    |NULL   |No Change|
|2013      |Half-Finger Gloves- M          |11376        |3992.00  |7384.00   |Above average|24      |11352  |Increased|
|2014      |Half-Finger Gloves- M          |576          |3992.00  |-3416.00  |Below average|11376   |-10800 |Decreased|
|2012      |Half-Finger Gloves- S          |24           |2928.00  |-2904.00  |Below average|NULL    |NULL   |No Change|
|2013      |Half-Finger Gloves- S          |11064        |2928.00  |8136.00   |Above average|24      |11040  |Increased|
-------------
