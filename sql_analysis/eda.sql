/*
QATAR MART RETAIL & E-COMMERCE
02 - EXPLORATORY DATA ANALYSIS

Purpose:
Understand the structure, distributions, trends, customers,
products, channels, geography, and order statuses before
deep-dive sales and root-cause analysis.
*/

-- ============================================================
-- 1. OVERALL DATASET PROFILE
-- ============================================================

SELECT
    COUNT(*) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(SUM(sales_amount) / COUNT(DISTINCT order_id), 2) AS aov
FROM qatar_mart_sales;

-- ============================================================
-- 2. MONTHLY PERFORMANCE
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(
        SUM(sales_amount) / COUNT(DISTINCT order_id),
        2
    ) AS aov
FROM qatar_mart_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- ============================================================
-- 3. MONTH-OVER-MONTH REVENUE
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(sales_amount) AS revenue
    FROM qatar_mart_sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
with_previous AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_revenue
    FROM monthly_sales
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_revenue, 2) AS previous_revenue,
    ROUND(
        (revenue - previous_revenue) /
        NULLIF(previous_revenue, 0) * 100,
        2
    ) AS revenue_mom_pct
FROM with_previous
ORDER BY month;

-- ============================================================
-- 4. SALES CHANNEL PERFORMANCE
-- ============================================================

SELECT
    sales_channel,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(
        SUM(sales_amount) /
        SUM(SUM(sales_amount)) OVER () * 100,
        2
    ) AS revenue_share_pct,
    ROUND(
        SUM(sales_amount) /
        COUNT(DISTINCT order_id),
        2
    ) AS aov
FROM qatar_mart_sales
GROUP BY sales_channel
ORDER BY revenue DESC;

-- ============================================================
-- 5. CITY PERFORMANCE
-- ============================================================

SELECT
    city,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(
        SUM(sales_amount) /
        COUNT(DISTINCT order_id),
        2
    ) AS aov
FROM qatar_mart_sales
GROUP BY city
ORDER BY revenue DESC;

-- ============================================================
-- 6. PRODUCT CATEGORY PERFORMANCE
-- ============================================================

SELECT
    product_category,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(
        SUM(sales_amount) /
        SUM(SUM(sales_amount)) OVER () * 100,
        2
    ) AS revenue_share_pct
FROM qatar_mart_sales
GROUP BY product_category
ORDER BY revenue DESC;

-- ============================================================
-- 7. TOP PRODUCTS
-- ============================================================

SELECT
    product,
    product_category,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS revenue,
    COUNT(DISTINCT order_id) AS orders
FROM qatar_mart_sales
GROUP BY product, product_category
ORDER BY revenue DESC
LIMIT 20;

-- ============================================================
-- 8. ORDER STATUS
-- ============================================================

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS sales_value,
    ROUND(
        SUM(sales_amount) /
        SUM(SUM(sales_amount)) OVER () * 100,
        2
    ) AS value_share_pct
FROM qatar_mart_sales
GROUP BY order_status
ORDER BY sales_value DESC;

-- ============================================================
-- 9. PAYMENT METHOD
-- ============================================================

SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(
        SUM(sales_amount) /
        COUNT(DISTINCT order_id),
        2
    ) AS aov
FROM qatar_mart_sales
GROUP BY payment_method
ORDER BY revenue DESC;

-- ============================================================
-- 10. CUSTOMER PURCHASE BEHAVIOR
-- ============================================================

WITH customer_summary AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS orders,
        SUM(quantity) AS units_sold,
        SUM(sales_amount) AS revenue
    FROM qatar_mart_sales
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS customers,
    ROUND(AVG(orders), 2) AS avg_orders_per_customer,
    ROUND(AVG(revenue), 2) AS avg_customer_revenue,
    SUM(orders > 1) AS repeat_customers,
    ROUND(
        SUM(orders > 1) / COUNT(*) * 100,
        2
    ) AS repeat_customer_pct
FROM customer_summary;

-- ============================================================
-- 11. AGE GROUP PERFORMANCE
-- ============================================================

SELECT
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 65 THEN '55-65'
    END AS age_group,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales_amount), 2) AS revenue
FROM qatar_mart_sales
GROUP BY age_group
ORDER BY revenue DESC;

-- ============================================================
-- 12. GENDER PERFORMANCE
-- ============================================================

SELECT
    gender,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(
        SUM(sales_amount) /
        COUNT(DISTINCT order_id),
        2
    ) AS aov
FROM qatar_mart_sales
GROUP BY gender
ORDER BY revenue DESC;

