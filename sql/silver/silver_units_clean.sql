CREATE DATABASE IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.units_clean;

CREATE TABLE silver.units_clean AS
SELECT
    id AS unit_id,
    course_id,
    `order` AS unit_order,
    status AS unit_status,
    is_foundation,
    created_at AS unit_created_at,
    updated_at AS unit_updated_at,
    DATE(created_at) AS report_date
FROM bronze.units
WHERE deleted_at IS NULL;

ALTER TABLE silver.units_clean
    ADD INDEX idx_units_clean_unit_id (unit_id),
    ADD INDEX idx_units_clean_report_date (report_date),
    ADD INDEX idx_units_clean_course_id (course_id);
