CREATE DATABASE IF NOT EXISTS dwh_gold;

CREATE OR REPLACE VIEW dwh_gold.financial_daily_report_formatted AS
SELECT
    report_date,
    total_sales,
    invoices_created,
    invoices_total,
    cash_collected,
    outstanding_amount,
    collection_rate,
    avg_order_value,
    revenue_growth
FROM dwh_gold.financial_daily_report;
