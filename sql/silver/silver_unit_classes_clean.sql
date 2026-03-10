CREATE DATABASE IF NOT EXISTS dwh_silver;

DROP TABLE IF EXISTS dwh_silver.unit_classes_clean;

CREATE TABLE dwh_silver.unit_classes_clean AS
SELECT
    id AS class_id,
    unit_id,
    link_type_id,
    exam_id,
    `order` AS class_order,
    duration,
    lesson_type,
    recording_type,
    recording_url,
    alternative_link,
    interactive_link,
    status AS class_status,
    is_free,
    is_moatheo,
    moatheo_id,
    created_at AS class_created_at,
    updated_at AS class_updated_at,
    DATE(created_at) AS report_date
FROM dwh_bronze.unit_classes
WHERE deleted_at IS NULL;

ALTER TABLE dwh_silver.unit_classes_clean
    ADD INDEX idx_unit_classes_clean_class_id (class_id),
    ADD INDEX idx_unit_classes_clean_report_date (report_date),
    ADD INDEX idx_unit_classes_clean_unit_id (unit_id),
    ADD INDEX idx_unit_classes_clean_link_type_id (link_type_id),
    ADD INDEX idx_unit_classes_clean_exam_id (exam_id),
    ADD INDEX idx_unit_classes_clean_moatheo_id (moatheo_id);
