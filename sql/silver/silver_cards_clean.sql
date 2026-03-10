CREATE DATABASE IF NOT EXISTS dwh_silver;

DROP TABLE IF EXISTS dwh_silver.cards_clean;

CREATE TABLE dwh_silver.cards_clean AS
SELECT
    id AS card_id,
    course_id,
    bulk_id,
    sales_point_transaction_id,
    expiry_date_id,
    semester_id,
    serial,
    barcode,
    mobile,
    status AS card_status,
    balance,
    actual_balance,
    used_at,
    sold_in,
    sold_to,
    export_to,
    export_in,
    is_blocked,
    is_draft,
    no_balance_deduction,
    created_at AS card_created_at,
    updated_at AS card_updated_at,
    DATE(created_at) AS report_date
FROM dwh_bronze.cards
WHERE deleted_at IS NULL;

ALTER TABLE dwh_silver.cards_clean
    ADD INDEX idx_cards_clean_card_id (card_id),
    ADD INDEX idx_cards_clean_report_date (report_date),
    ADD INDEX idx_cards_clean_course_id (course_id),
    ADD INDEX idx_cards_clean_bulk_id (bulk_id),
    ADD INDEX idx_cards_clean_sales_point_transaction_id (sales_point_transaction_id(191)),
    ADD INDEX idx_cards_clean_expiry_date_id (expiry_date_id),
    ADD INDEX idx_cards_clean_semester_id (semester_id(191));
