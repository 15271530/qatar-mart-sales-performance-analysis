/*
QATAR MART RETAIL & E-COMMERCE
03 - SALES PERFORMANCE ANALYSIS

Purpose:
Answer the core business question:

"How is the business performing, what is driving sales
performance, and where are the biggest opportunities or problems?"
*/

-- ============================================================
-- 1. NORTH-STAR KPI SUMMARY
-- ============================================================

SELECT
    ROUND(SUM(sales_amount), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
        SUM(sales_amount) / COUNT(DISTINCT order_id),
        2
    ) AS aov
FROM qatar_mart_sales;

-- ============================================================
-- 2. MONTHLY KPI TREND + MOM CHANGE
-- ============================================================

WITH monthly AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(sales_amount) AS revenue,
        COUNT(DISTINCT order_id) AS orders,
        SUM(quantity) AS units,
        SUM(sales_amount) /
            COUNT(DISTINCT order_id) AS aov
    FROM qatar_mart_sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
trend AS (
    SELECT
        *,
        LAG(revenue) OVER (ORDER BY month) AS previous_revenue,
        LAG(orders) OVER (ORDER BY month) AS previous_orders,
        LAG(units) OVER (ORDER BY month) AS previous_units,
        LAG(aov) OVER (ORDER BY month) AS previous_aov
    FROM monthly
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    orders,
    units,
    ROUND(aov, 2) AS aov,
    ROUND(
        (revenue - previous_revenue) /
        NULLIF(previous_revenue, 0) * 100,
        2
    ) AS revenue_change_pct,
    ROUND(
        (orders - previous_orders) /
        NULLIF(previous_orders, 0) * 100,
        2
    ) AS orders_change_pct,
    ROUND(
        (units - previous_units) /
        NULLIF(previous_units, 0) * 100,
        2
    ) AS units_change_pct,
    ROUND(
        (aov - previous_aov) /
        NULLIF(previous_aov, 0) * 100,
        2
    ) AS aov_change_pct
FROM trend
ORDER BY month;

-- ============================================================
-- 3. REVENUE CONTRIBUTION BY CHANNEL
-- ============================================================

SELECT
    sales_channel,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(
        SUM(sales_amount) /
        SUM(SUM(sales_amount)) OVER () * 100,
        2
    ) AS revenue_share_pct,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units,
    ROUND(
        SUM(sales_amount) /
        COUNT(DISTINCT order_id),
        2
    ) AS aov
FROM qatar_mart_sales
GROUP BY sales_channel
ORDER BY revenue DESC;

-- ============================================================
-- 4. CHANNEL × ORDER STATUS
-- Identifies where pending/cancelled/returned value is concentrated.
-- ============================================================

SELECT
    sales_channel,
    order_status,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales_amount), 2) AS sales_value
FROM qatar_mart_sales
GROUP BY sales_channel, order_status
ORDER BY sales_channel, sales_value DESC;

-- ============================================================
-- 5. CITY CONTRIBUTION
-- ============================================================

SELECT
    city,
    ROUND(SUM(sales_amount), 2) AS revenue,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units,
    ROUND(
        SUM(sales_amount) /
        COUNT(DISTINCT order_id),
        2
    ) AS aov,
    ROUND(
        SUM(sales_amount) /
        SUM(SUM(sales_amount)) OVER () * 100,
        2
    ) AS revenue_share_pct
FROM qatar_mart_sales
GROUP BY city
ORDER BY revenue DESC;

-- ============================================================
-- 6. CATEGORY × CHANNEL
-- ============================================================

SELECT
    product_category,
    sales_channel,
    ROUND(SUM(sales_amount), 2) AS revenue,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units,
    ROUND(
        SUM(sales_amount) /
        COUNT(DISTINCT order_id),
        2
    ) AS aov
FROM qatar_mart_sales
GROUP BY product_category, sales_channel
ORDER BY revenue DESC;

-- ============================================================
-- 7. TOP 20 PRODUCTS BY REVENUE
-- ============================================================

SELECT
    product,
    product_category,
    ROUND(SUM(sales_amount), 2) AS revenue,
    SUM(quantity) AS units,
    COUNT(DISTINCT order_id) AS orders
FROM qatar_mart_sales
GROUP BY product, product_category
ORDER BY revenue DESC
LIMIT 20;

-- ============================================================
-- 8. REVENUE BY ORDER STATUS
-- Shows completed value versus pending/cancelled/returned value.
-- ============================================================

SELECT
    order_status,
    ROUND(SUM(sales_amount), 2) AS sales_value,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(
        SUM(sales_amount) /
        SUM(SUM(sales_amount)) OVER () * 100,
        2
    ) AS value_share_pct
FROM qatar_mart_sales
GROUP BY order_status
ORDER BY sales_value DESC;

-- ============================================================
-- 9. NON-COMPLETED SALES VALUE
-- ============================================================

SELECT
    ROUND(
        SUM(
            CASE
                WHEN order_status <> 'Completed'
                THEN sales_amount
                ELSE 0
            END
        ),
        2
    ) AS non_completed_value,
    ROUND(
        SUM(
            CASE
                WHEN order_status <> 'Completed'
                THEN sales_amount
                ELSE 0
            END
        ) / SUM(sales_amount) * 100,
        2
    ) AS non_completed_value_pct
FROM qatar_mart_sales;

-- ============================================================
-- 10. MONTHLY COMPLETED VS NON-COMPLETED VALUE
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'Completed'
                THEN sales_amount ELSE 0
            END
        ),
        2
    ) AS completed_value,
    ROUND(
        SUM(
            CASE
                WHEN order_status <> 'Completed'
                THEN sales_amount ELSE 0
            END
        ),
        2
    ) AS non_completed_value
FROM qatar_mart_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- ============================================================
-- 11. YEAR-OVER-YEAR PERFORMANCE FOR COMPARABLE MONTHS
-- 2026 only contains Jan-Jun, so compare Jan-Jun 2025 vs Jan-Jun 2026.
-- ============================================================

WITH period_sales AS (
    SELECT
        YEAR(order_date) AS year,
        SUM(sales_amount) AS revenue,
        COUNT(DISTINCT order_id) AS orders,
        SUM(quantity) AS units
    FROM qatar_mart_sales
    WHERE MONTH(order_date) <= 6
    GROUP BY YEAR(order_date)
)
SELECT
    year,
    ROUND(revenue, 2) AS revenue,
    orders,
    units,
    ROUND(
        revenue / NULLIF(orders, 0),
        2
    ) AS aov
FROM period_sales
ORDER BY year;

-- ============================================================
-- 12. REVENUE RANKING BY CITY
-- ============================================================

WITH city_sales AS (
    SELECT
        city,
        SUM(sales_amount) AS revenue
    FROM qatar_mart_sales
    GROUP BY city
)
SELECT
    city,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM city_sales
ORDER BY revenue_rank;

