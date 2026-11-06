# Olist E-commerce Data Analysis (SQL)

## Project Overview

This project is based on the Olist E-commerce dataset. The main objective of this project is to clean the data, validate data quality, build relationships between tables, and answer business questions using PostgreSQL.

In this project, I cleaned the dataset, validated data quality, built relationships between tables, and answered business questions using SQL. This project helped me understand how SQL is used in real-world e-commerce data analysis.
---

# Dataset
The project contains the following tables:

- olist_customers
- olist_orders
- olist_order_items
- olist_order_payments
- olist_order_reviews
- olist_products
- olist_sellers
- olist_geolocation
- product_category_name

---
# Data Cleaning & Validation

Before starting the analysis, I validated the quality of the dataset by checking data types, missing values, duplicate records, and relationships between tables.

### Data Type Validation

I verified the data type of every column using the `information_schema.columns` table to ensure each column had the correct data type before starting the analysis.

### Missing Value Analysis

I checked missing values in every table using PostgreSQL's `FILTER` clause.

During the validation process, I found:

- `product_name_length` contained missing values. I calculated the median using `PERCENTILE_CONT(0.5)` and replaced the NULL values with the median because the median is less affected by outliers than the average.
- `order_approved_at` contained **160** NULL values. These records belonged to orders that were not approved, so they were kept unchanged.
- `order_delivered_carrier_date` contained **1,783** NULL values and `order_delivered_customer_date` contained **2,965** NULL values. Most of these records belonged to cancelled, unavailable, or incomplete orders, so they were considered valid business cases and were not modified.
- During validation, I found **2 delivered orders** with a missing `order_delivered_carrier_date` and **8 delivered orders** with a missing `order_delivered_customer_date`. Since these records were inconsistent with their order status, I treated them as data quality issues and excluded them from delivery time analysis.
- `review_comment_title` contained **87,656** NULL values and `review_comment_message` contained **58,247** NULL values. These fields are optional, so the missing values were retained instead of being replaced.

### Duplicate Check

I checked every table for duplicate records using `GROUP BY` and `HAVING COUNT(*) > 1` to make sure there were no duplicate records affecting the analysis.

### Primary Key Validation

I verified that all primary key columns did not contain NULL values.

### Relationship Validation

I validated the relationships between all related tables using `LEFT JOIN` before creating foreign key constraints. After confirming that there were no missing reference records, I created foreign key constraints to maintain referential integrity.

---

# SQL Concepts Used
During this project, I used the following SQL concepts:

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- JOIN
- LEFT JOIN
- CASE WHEN
- Aggregate Functions
- COUNT
- SUM
- AVG
- ROUND
- DISTINCT
- EXTRACT
- FILTER
- PERCENTILE_CONT
- ALTER TABLE
- FOREIGN KEY

---

# Business Analysis

The following business questions were answered using SQL:

- - Total and unique customers
- Customer distribution by state
- Revenue by product category
- Products sold by year and month
- New vs. repeat customers
- Top customer cities
- Highest spending customers
- Most sold products
- Highest revenue categories
- Average product price by category
- Product weight vs. freight cost analysis

---

# Key Learnings

Through this project, I learned how to:

- Perform data cleaning using SQL.
- Identify missing values and decide whether they should be filled or kept.
- Use median instead of average when appropriate.
- Check duplicate records.
- Validate relationships between multiple tables.
- Create foreign key constraints.
- Write SQL queries to answer business questions.
- Work with a relational database containing multiple connected tables.

---

# Tools Used

- PostgreSQL
- pgAdmin 4

---

# Conclusion

This project gave me hands-on experience working with a real-world e-commerce dataset. It improved my SQL skills in data cleaning, data validation, relationship building, and business analysis. Through this project, I also gained a better understanding of relational databases and how SQL is used to solve real business problems.

# Project Files
- `olist_sql_analysis.sql` – SQL queries for data cleaning, validation, relationship checks, and business analysis.
- `README.md` – Documentation of the project.

  ## Notes

- The `olist_geolocation_dataset.csv` file is not included in this repository because it exceeds GitHub's web upload size limit.
- You can download the complete dataset from the official Olist dataset on Kaggle if needed.
