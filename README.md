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
