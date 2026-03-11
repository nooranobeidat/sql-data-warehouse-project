CREATE DATABASE IF NOT EXISTS dwh_gold;

DROP TABLE IF EXISTS dwh_gold.financial_daily_report;

CREATE TABLE dwh_gold.financial_daily_report AS
WITH daily_orders AS (
    SELECT
        report_date,
        SUM(total_amount) AS total_sales,
        COUNT(order_id) AS orders_count
    FROM dwh_silver.orders_clean
    GROUP BY report_date
),
daily_invoices AS (
    SELECT
        report_date,
        COUNT(invoice_id) AS invoices_created,
        SUM(invoice_amount) AS invoices_total,
        SUM(collected_amount) AS cash_collected
    FROM dwh_silver.invoices_clean
    GROUP BY report_date
),
all_dates AS (
    SELECT report_date FROM daily_orders
    UNION
    SELECT report_date FROM daily_invoices
),
daily_financials AS (
    SELECT
        d.report_date,
        COALESCE(o.total_sales, 0) AS total_sales,
        COALESCE(i.invoices_created, 0) AS invoices_created,
        COALESCE(i.invoices_total, 0) AS invoices_total,
        COALESCE(i.cash_collected, 0) AS cash_collected,
        COALESCE(o.orders_count, 0) AS orders_count
    FROM all_dates AS d
    LEFT JOIN daily_orders AS o
        ON d.report_date = o.report_date
    LEFT JOIN daily_invoices AS i
        ON d.report_date = i.report_date
),
growth_base AS (
    SELECT
        report_date,
        total_sales,
        invoices_created,
        invoices_total,
        cash_collected,
        invoices_total - cash_collected AS outstanding_amount,
        CASE
            WHEN invoices_total = 0 THEN NULL
            ELSE cash_collected / invoices_total
        END AS collection_rate,
        CASE
            WHEN orders_count = 0 THEN NULL
            ELSE total_sales / orders_count
        END AS avg_order_value,
        LAG(total_sales) OVER (ORDER BY report_date) AS previous_total_sales
    FROM daily_financials
)
SELECT
    report_date,
    FORMAT(total_sales, 0) AS total_sales,
    FORMAT(invoices_created, 0) AS invoices_created,
    FORMAT(invoices_total, 2) AS invoices_total,
    FORMAT(cash_collected, 2) AS cash_collected,
    FORMAT(outstanding_amount, 2) AS outstanding_amount,
    CONCAT(ROUND(collection_rate * 100, 2), ' %') AS collection_rate,
    FORMAT(avg_order_value, 2) AS avg_order_value,
    CONCAT(
        ROUND(
            CASE
                WHEN previous_total_sales IS NULL OR previous_total_sales = 0 THEN NULL
                ELSE (total_sales - previous_total_sales) / previous_total_sales
            END * 100,
            2
        ),
        ' %'
    ) AS revenue_growth
FROM growth_base
ORDER BY report_date;
