CREATE DATABASE IF NOT EXISTS dwh_gold;

DROP TABLE IF EXISTS dwh_gold.marketing_daily_report;

CREATE TABLE dwh_gold.marketing_daily_report AS
WITH daily_new_users AS (
    SELECT
        report_date,
        COUNT(user_id) AS new_users
    FROM dwh_silver.users_clean
    GROUP BY report_date
),
daily_buyers AS (
    SELECT
        report_date,
        COUNT(DISTINCT user_id) AS total_buyers
    FROM dwh_silver.orders_clean
    GROUP BY report_date
),
daily_new_user_buyers AS (
    SELECT
        u.report_date,
        COUNT(DISTINCT u.user_id) AS buyers_from_new_users
    FROM dwh_silver.users_clean AS u
    INNER JOIN dwh_silver.orders_clean AS o
        ON u.user_id = o.user_id
       AND u.report_date = o.report_date
    GROUP BY u.report_date
),
daily_repeat_buyers AS (
    SELECT
        report_date,
        COUNT(*) AS repeat_buyers
    FROM (
        SELECT
            report_date,
            user_id
        FROM dwh_silver.orders_clean
        GROUP BY report_date, user_id
        HAVING COUNT(order_id) > 1
    ) AS same_day_repeat_buyers
    GROUP BY report_date
),
all_dates AS (
    SELECT report_date FROM daily_new_users
    UNION
    SELECT report_date FROM daily_buyers
    UNION
    SELECT report_date FROM daily_new_user_buyers
    UNION
    SELECT report_date FROM daily_repeat_buyers
)
SELECT
    d.report_date,
    FORMAT(COALESCE(nu.new_users, 0), 0) AS new_users,
    FORMAT(COALESCE(nb.buyers_from_new_users, 0), 0) AS buyers_from_new_users,
    CONCAT(
        ROUND(
            CASE
                WHEN COALESCE(nu.new_users, 0) = 0 THEN NULL
                ELSE COALESCE(nb.buyers_from_new_users, 0) / nu.new_users
            END * 100,
            2
        ),
        ' %'
    ) AS conversion_rate,
    CONCAT(
        ROUND(
            CASE
                WHEN COALESCE(b.total_buyers, 0) = 0 THEN NULL
                ELSE COALESCE(rb.repeat_buyers, 0) / b.total_buyers
            END * 100,
            2
        ),
        ' %'
    ) AS returning_buyers_rate
FROM all_dates AS d
LEFT JOIN daily_new_users AS nu
    ON d.report_date = nu.report_date
LEFT JOIN daily_buyers AS b
    ON d.report_date = b.report_date
LEFT JOIN daily_new_user_buyers AS nb
    ON d.report_date = nb.report_date
LEFT JOIN daily_repeat_buyers AS rb
    ON d.report_date = rb.report_date
ORDER BY d.report_date;
