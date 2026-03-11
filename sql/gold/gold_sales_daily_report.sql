CREATE DATABASE IF NOT EXISTS dwh_gold;

DROP TABLE IF EXISTS dwh_gold.sales_daily_report;

CREATE TABLE dwh_gold.sales_daily_report AS
WITH daily_sales AS (
    SELECT
        report_date,
        SUM(total_amount) AS sales,
        COUNT(DISTINCT user_id) AS buyers_count,
        COUNT(order_id) AS orders_count
    FROM dwh_silver.orders_clean
    GROUP BY report_date
),
growth_base AS (
    SELECT
        report_date,
        sales,
        buyers_count,
        CASE
            WHEN orders_count = 0 THEN NULL
            ELSE sales / orders_count
        END AS avg_order_value,
        LAG(sales) OVER (ORDER BY report_date) AS previous_sales
    FROM daily_sales
)
SELECT
    report_date,
    FORMAT(sales, 0) AS sales,
    FORMAT(buyers_count, 0) AS buyers_count,
    FORMAT(avg_order_value, 2) AS avg_order_value,
    CONCAT(
        ROUND(
            CASE
                WHEN previous_sales IS NULL OR previous_sales = 0 THEN NULL
                ELSE (sales - previous_sales) / previous_sales
            END * 100,
            2
        ),
        ' %'
    ) AS sales_growth
FROM growth_base
ORDER BY report_date;
