/* =====================================================================
   OLIST E-COMMERCE ANALYSIS (PostgreSQL)

   Part 1: Data Quality Checks
   Part 2: Schema Changes & Foreign Keys
   Part 3: Data Cleaning
   Part 4: Analysis
           4.1 Orders      4.2 Customers   4.3 Products
           4.4 Delivery    4.5 Reviews     4.6 Payments
           4.7 Sellers
   ===================================================================== */


/* =====================================================================
   PART 1: DATA QUALITY CHECKS
   ===================================================================== */

-- ---------------------------------------------------------------------
-- Table 1: olist_customers
-- ---------------------------------------------------------------------
SELECT * FROM olist_customers;

-- Data types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'olist_customers';

-- Null values
SELECT
    COUNT(*) FILTER (WHERE customer_id        IS NULL) AS customer_id_null,
    COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS customer_unique_id_null,
    COUNT(*) FILTER (WHERE customer_state     IS NULL) AS customer_state_null
FROM olist_customers;

-- Unique customer_id / customer_unique_id
SELECT DISTINCT customer_id, customer_unique_id
FROM olist_customers;

-- Duplicates
SELECT customer_id, customer_unique_id, COUNT(*) AS cnt
FROM olist_customers
GROUP BY customer_id, customer_unique_id
HAVING COUNT(*) > 1;

-- Null values in remaining columns
SELECT
    COUNT(*) FILTER (WHERE customer_zip_code_prefix IS NULL) AS zip_null,
    COUNT(*) FILTER (WHERE customer_city            IS NULL) AS city_null
FROM olist_customers;


-- ---------------------------------------------------------------------
-- Table 2: olist_geolocation
-- ---------------------------------------------------------------------
SELECT * FROM olist_geolocation;

-- Data types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'olist_geolocation';

-- Null values
SELECT
    COUNT(*) FILTER (WHERE geolocation_zip_code_prefix IS NULL) AS zip_null,
    COUNT(*) FILTER (WHERE geolocation_state           IS NULL) AS state_null
FROM olist_geolocation;

-- Unique zip prefixes
SELECT DISTINCT geolocation_zip_code_prefix
FROM olist_geolocation;

-- Duplicates
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS cnt
FROM olist_geolocation
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1;


-- ---------------------------------------------------------------------
-- Table 3: olist_order_items
-- ---------------------------------------------------------------------
SELECT * FROM olist_order_items;

-- Data types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'olist_order_items';

-- Null values
SELECT
    COUNT(*) FILTER (WHERE order_id      IS NULL) AS order_id_null,
    COUNT(*) FILTER (WHERE order_item_id IS NULL) AS order_item_id_null,
    COUNT(*) FILTER (WHERE product_id    IS NULL) AS product_id_null
FROM olist_order_items;

-- Duplicates
SELECT order_id, order_item_id, product_id, COUNT(*) AS cnt
FROM olist_order_items
GROUP BY order_id, order_item_id, product_id
HAVING COUNT(*) > 1;

-- Null values in price / freight
SELECT
    COUNT(*) FILTER (WHERE price         IS NULL) AS price_null,
    COUNT(*) FILTER (WHERE freight_value IS NULL) AS freight_value_null
FROM olist_order_items;


-- ---------------------------------------------------------------------
-- Table 4: olist_order_payments
-- ---------------------------------------------------------------------
SELECT * FROM olist_order_payments;

-- Data types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'olist_order_payments';

-- Null values
SELECT COUNT(*) AS order_id_null
FROM olist_order_payments
WHERE order_id IS NULL;

-- Duplicates
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    COUNT(*) AS cnt
FROM olist_order_payments
GROUP BY
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
HAVING COUNT(*) > 1;


-- ---------------------------------------------------------------------
-- Table 5: olist_order_reviews
-- ---------------------------------------------------------------------
SELECT * FROM olist_order_reviews;

-- Data types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'olist_order_reviews';

-- Null values
SELECT
    COUNT(*) FILTER (WHERE review_id IS NULL) AS review_id_null,
    COUNT(*) FILTER (WHERE order_id  IS NULL) AS order_id_null
FROM olist_order_reviews;

-- Duplicates
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    COUNT(*) AS cnt
FROM olist_order_reviews
GROUP BY
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message
HAVING COUNT(*) > 1;


-- ---------------------------------------------------------------------
-- Table 6: olist_orders
-- ---------------------------------------------------------------------
SELECT * FROM olist_orders;

-- 1. Total rows
SELECT COUNT(*) AS total_rows FROM olist_orders;

-- 2. Null values in date columns
SELECT
    COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS customer_date_null,
    COUNT(*) FILTER (WHERE order_delivered_carrier_date  IS NULL) AS carrier_date_null
FROM olist_orders;

-- 3. Order status where carrier date is NULL
SELECT order_status, COUNT(*) AS cnt
FROM olist_orders
WHERE order_delivered_carrier_date IS NULL
GROUP BY order_status;

-- 4. Delivered orders with NULL carrier date
SELECT *
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_carrier_date IS NULL;

-- 5. Delivered orders with NULL customer date
SELECT *
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

-- 6. Canceled orders with customer date filled
SELECT *
FROM olist_orders
WHERE order_status = 'canceled'
  AND order_delivered_customer_date IS NOT NULL;

-- 7. Canceled orders with carrier date filled
SELECT *
FROM olist_orders
WHERE order_status = 'canceled'
  AND order_delivered_carrier_date IS NOT NULL;

-- 8. Distinct order status
SELECT DISTINCT order_status
FROM olist_orders;

-- 9. Duplicates
SELECT order_id, customer_id, COUNT(*) AS cnt
FROM olist_orders
GROUP BY order_id, customer_id
HAVING COUNT(*) > 1;

-- 10. Null estimated delivery date
SELECT COUNT(*) AS estimated_delivery_null
FROM olist_orders
WHERE order_estimated_delivery_date IS NULL;

-- 11. Delivered orders with NULL carrier date (count)
SELECT COUNT(*) AS delivered_no_carrier_date
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_carrier_date IS NULL;

-- 12. Delivered orders with NULL customer date (count)
SELECT COUNT(*) AS delivered_no_customer_date
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;


-- ---------------------------------------------------------------------
-- Table 7: olist_products
-- ---------------------------------------------------------------------
SELECT * FROM olist_products;

-- Data types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'olist_products';

-- Null values
SELECT COUNT(*) AS product_id_null
FROM olist_products
WHERE product_id IS NULL;

-- Duplicates
SELECT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_width_cm,
    COUNT(*) AS cnt
FROM olist_products
GROUP BY
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_width_cm
HAVING COUNT(*) > 1;


-- ---------------------------------------------------------------------
-- Table 8: olist_sellers
-- ---------------------------------------------------------------------
SELECT * FROM olist_sellers;

-- Data types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'olist_sellers';

-- Null values
SELECT COUNT(*) AS seller_id_null
FROM olist_sellers
WHERE seller_id IS NULL;

-- Duplicates
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    COUNT(*) AS cnt
FROM olist_sellers
GROUP BY seller_id, seller_zip_code_prefix, seller_city, seller_state
HAVING COUNT(*) > 1;


-- ---------------------------------------------------------------------
-- Table 9: product_category_name
-- ---------------------------------------------------------------------
SELECT * FROM product_category_name;

-- Data types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'product_category_name';


-- ---------------------------------------------------------------------
-- Relationship checks (orphan records; all should return 0)
-- ---------------------------------------------------------------------

-- customers -> orders (customers without any order)
SELECT COUNT(*) AS customers_without_orders
FROM olist_customers oc
LEFT JOIN olist_orders o ON oc.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- order_items -> orders
SELECT COUNT(*) AS items_without_order
FROM olist_order_items oi
LEFT JOIN olist_orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- order_items -> products
SELECT COUNT(*) AS items_without_product
FROM olist_order_items oi
LEFT JOIN olist_products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- order_items -> sellers
SELECT COUNT(*) AS items_without_seller
FROM olist_order_items oi
LEFT JOIN olist_sellers s ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


/* =====================================================================
   PART 2: SCHEMA CHANGES & FOREIGN KEYS
   (Note: referenced columns must be PRIMARY KEY / UNIQUE, otherwise
    the FK statements will fail.)
   ===================================================================== */

-- Rename column
ALTER TABLE olist_products
RENAME COLUMN product_category_name TO p_category_name;

-- Foreign keys
ALTER TABLE olist_orders
    ADD CONSTRAINT fk_orders_customers
    FOREIGN KEY (customer_id) REFERENCES olist_customers (customer_id);

ALTER TABLE olist_order_items
    ADD CONSTRAINT fk_orderitems_orders
    FOREIGN KEY (order_id) REFERENCES olist_orders (order_id);

ALTER TABLE olist_order_items
    ADD CONSTRAINT fk_orderitems_products
    FOREIGN KEY (product_id) REFERENCES olist_products (product_id);

ALTER TABLE olist_order_items
    ADD CONSTRAINT fk_orderitems_sellers
    FOREIGN KEY (seller_id) REFERENCES olist_sellers (seller_id);

ALTER TABLE olist_order_payments
    ADD CONSTRAINT fk_payments_orders
    FOREIGN KEY (order_id) REFERENCES olist_orders (order_id);

ALTER TABLE olist_order_reviews
    ADD CONSTRAINT fk_reviews_orders
    FOREIGN KEY (order_id) REFERENCES olist_orders (order_id);

-- Verify foreign keys
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.constraint_type = 'FOREIGN KEY';


/* =====================================================================
   PART 3: DATA CLEANING
   ===================================================================== */

-- NULL category count (before update)
SELECT COUNT(*) AS null_category_count
FROM olist_products
WHERE p_category_name IS NULL;

-- Fill NULL category with 'Unknown'
UPDATE olist_products
SET p_category_name = 'Unknown'
WHERE p_category_name IS NULL;

-- Products with 'Unknown' category (verify)
SELECT p_category_name
FROM olist_products
WHERE p_category_name = 'Unknown';

-- Median of product_name_length
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_name_lenght) AS median
FROM olist_products;


-- Fill NULL product_name_length with the median
UPDATE olist_products
SET product_name_lenght = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_name_lenght)
    FROM olist_products
)
WHERE product_name_lenght IS NULL;

-- Median of product_weight_g
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_weight_g) AS median
FROM olist_products;

UPDATE olist_products
SET product_weight_g = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_weight_g)
    FROM olist_products
)
WHERE product_weight_g IS NULL;

-- Median of product_length_cm
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_length_cm) AS median
FROM olist_products;

UPDATE olist_products
SET product_length_cm = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_length_cm)
    FROM olist_products
)
WHERE product_length_cm IS NULL;

-- Median of product_height_cm
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_height_cm) AS median
FROM olist_products;


UPDATE olist_products
SET product_height_cm = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_height_cm)
    FROM olist_products
)
WHERE product_height_cm IS NULL;

-- Median of product_width_cm
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_width_cm) AS median
FROM olist_products;


UPDATE olist_products
SET product_width_cm = (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_width_cm)
    FROM olist_products
)
WHERE product_width_cm IS NULL;


/* =====================================================================
   PART 4: ANALYSIS
   ===================================================================== */

-- =====================================================================
-- 4.1 ORDERS ANALYSIS
-- =====================================================================

-- Order status distribution
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_orders), 2) AS percentage
FROM olist_orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Products sold per year and month
SELECT
    EXTRACT(YEAR  FROM shipping_limit_date) AS year,
    EXTRACT(MONTH FROM shipping_limit_date) AS month,
    COUNT(product_id)                       AS products_sold
FROM olist_order_items
GROUP BY 1, 2
ORDER BY 1, 2;


-- =====================================================================
-- 4.2 CUSTOMER ANALYSIS
-- =====================================================================

-- Total customers
SELECT COUNT(*) AS total_customers
FROM olist_customers;

-- Total unique customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_unique_customers
FROM olist_customers;

-- Customers appearing more than once
SELECT customer_unique_id, COUNT(*) AS cnt
FROM olist_customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;

-- State-wise customers and % contribution
SELECT
    customer_state,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_customers), 2) AS percentage
FROM olist_customers
GROUP BY customer_state
ORDER BY percentage DESC;

-- Top 5 cities by customers
SELECT customer_city, COUNT(*) AS total_customers
FROM olist_customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 5;

-- New vs repeat customers (per customer)
SELECT
    oc.customer_unique_id,
    COUNT(o.order_id) AS orders,
    CASE WHEN COUNT(o.order_id) = 1 THEN 'New customer'
         ELSE 'Repeat customer'
    END AS customer_type
FROM olist_customers oc
JOIN olist_orders o ON oc.customer_id = o.customer_id
GROUP BY oc.customer_unique_id
ORDER BY customer_type DESC;

-- New vs repeat customers (summary)
SELECT customer_type, COUNT(*) AS total_customers
FROM (
    SELECT
        oc.customer_unique_id,
        CASE WHEN COUNT(o.order_id) = 1 THEN 'New customer'
             ELSE 'Repeat customer'
        END AS customer_type
    FROM olist_customers oc
    JOIN olist_orders o ON oc.customer_id = o.customer_id
    GROUP BY oc.customer_unique_id
) t
GROUP BY customer_type;

-- Highest spending customers
SELECT
    oc.customer_unique_id,
    SUM(op.payment_value) AS total_spending
FROM olist_customers oc
JOIN olist_orders o          ON oc.customer_id = o.customer_id
JOIN olist_order_payments op ON o.order_id     = op.order_id
GROUP BY oc.customer_unique_id
ORDER BY total_spending DESC
LIMIT 10;


-- =====================================================================
-- 4.3 PRODUCT ANALYSIS
-- =====================================================================

-- Revenue by product category
SELECT
    op.p_category_name,
    ROUND(SUM(oi.price), 2) AS revenue
FROM olist_products op
JOIN olist_order_items oi ON op.product_id = oi.product_id
GROUP BY op.p_category_name
ORDER BY revenue DESC;

-- Top 5 revenue categories
SELECT
    op.p_category_name,
    ROUND(SUM(oi.price), 2) AS revenue
FROM olist_products op
JOIN olist_order_items oi ON op.product_id = oi.product_id
GROUP BY op.p_category_name
ORDER BY revenue DESC
LIMIT 5;

-- Top 5 most sold products
SELECT product_id, COUNT(*) AS times_sold
FROM olist_order_items
GROUP BY product_id
ORDER BY times_sold DESC
LIMIT 5;

-- Top 5 most sold categories (by items actually sold)
SELECT
    op.p_category_name,
    COUNT(*) AS items_sold
FROM olist_products op
JOIN olist_order_items oi ON op.product_id = oi.product_id
GROUP BY op.p_category_name
ORDER BY items_sold DESC
LIMIT 5;

-- Average product price by category (top 10)
SELECT
    op.p_category_name,
    ROUND(AVG(oi.price), 2) AS avg_price
FROM olist_products op
JOIN olist_order_items oi ON op.product_id = oi.product_id
GROUP BY op.p_category_name
ORDER BY avg_price DESC
LIMIT 10;

-- Top 10 products by total freight cost
SELECT
    op.product_id,
    op.product_weight_g,
    SUM(oi.freight_value) AS freight_cost
FROM olist_products op
LEFT JOIN olist_order_items oi ON op.product_id = oi.product_id
GROUP BY op.product_id, op.product_weight_g
ORDER BY freight_cost DESC
LIMIT 10;

-- Average freight cost by product weight
SELECT
    op.product_weight_g,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_cost
FROM olist_products op
JOIN olist_order_items oi ON op.product_id = oi.product_id
WHERE op.product_weight_g IS NOT NULL
GROUP BY op.product_weight_g
ORDER BY op.product_weight_g;


-- =====================================================================
-- 4.4 DELIVERY ANALYSIS (purchase -> carrier handover, in hours)
-- =====================================================================

-- Top 5 fastest states
SELECT
    oc.customer_state,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_carrier_date
                                  - o.order_purchase_timestamp)) / 3600), 2) AS avg_hours
FROM olist_customers oc
JOIN olist_orders o ON o.customer_id = oc.customer_id
WHERE o.order_status = 'delivered'
GROUP BY oc.customer_state
ORDER BY avg_hours ASC
LIMIT 5;

-- Top 5 slowest states
SELECT
    oc.customer_state,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_carrier_date
                                  - o.order_purchase_timestamp)) / 3600), 2) AS avg_hours
FROM olist_customers oc
JOIN olist_orders o ON o.customer_id = oc.customer_id
WHERE o.order_status = 'delivered'
GROUP BY oc.customer_state
ORDER BY avg_hours DESC
LIMIT 5;


-- =====================================================================
-- 4.5 REVIEW ANALYSIS
-- =====================================================================

-- Order-wise average review score
SELECT order_id, ROUND(AVG(review_score), 2) AS avg_review_score
FROM olist_order_reviews
GROUP BY order_id;

-- Rating distribution
SELECT
    review_score,
    COUNT(review_id) AS total_reviews,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_order_reviews), 2) AS percentage
FROM olist_order_reviews
GROUP BY review_score
ORDER BY review_score ASC;

-- Revenue by review score
SELECT
    orv.review_score,
    ROUND(SUM(oi.price), 2) AS revenue
FROM olist_order_reviews orv
JOIN olist_order_items oi ON orv.order_id = oi.order_id
GROUP BY orv.review_score
ORDER BY orv.review_score;


-- =====================================================================
-- 4.6 PAYMENT ANALYSIS
-- =====================================================================

-- Payment type: total orders and percentage
SELECT
    payment_type,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_order_payments), 2) AS percentage
FROM olist_order_payments
GROUP BY payment_type
ORDER BY percentage DESC;

-- Payment type: revenue
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS revenue
FROM olist_order_payments
GROUP BY payment_type
ORDER BY revenue DESC;

-- Average payment value per order
SELECT
    order_id,
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM olist_order_payments
GROUP BY order_id
ORDER BY avg_payment_value DESC;


-- =====================================================================
-- 4.7 SELLER ANALYSIS
-- =====================================================================

-- Total sellers
SELECT COUNT(*) AS total_sellers
FROM olist_sellers;

-- Top 5 sellers by revenue
SELECT
    seller_id,
    ROUND(SUM(price), 2) AS revenue
FROM olist_order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 5;

-- Seller performance (revenue + average rating)
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2)        AS revenue,
    ROUND(AVG(orr.review_score), 2) AS avg_review_score
FROM olist_order_items oi
JOIN olist_order_reviews orr ON oi.order_id = orr.order_id
GROUP BY oi.seller_id
ORDER BY revenue DESC;
