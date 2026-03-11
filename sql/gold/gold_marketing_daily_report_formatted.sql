CREATE DATABASE IF NOT EXISTS dwh_gold;

CREATE OR REPLACE VIEW dwh_gold.marketing_daily_report_formatted AS
SELECT
    report_date,
    new_users,
    buyers_from_new_users,
    conversion_rate,
    returning_buyers_rate
FROM dwh_gold.marketing_daily_report;
