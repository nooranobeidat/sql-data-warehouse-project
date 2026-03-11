CREATE DATABASE IF NOT EXISTS dwh_gold;

CREATE OR REPLACE VIEW dwh_gold.sales_daily_report_formatted AS
SELECT
    report_date,
    sales,
    buyers_count,
    avg_order_value,
    sales_growth
FROM dwh_gold.sales_daily_report;
