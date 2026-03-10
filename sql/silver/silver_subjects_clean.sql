CREATE DATABASE IF NOT EXISTS dwh_silver;

DROP TABLE IF EXISTS dwh_silver.subjects_clean;

CREATE TABLE dwh_silver.subjects_clean AS
SELECT
    id AS subject_id,
    semester_id,
    academic_year_id,
    category_id,
    program_id,
    name AS subject_name,
    slug,
    status AS subject_status,
    `order` AS subject_order,
    weight,
    created_at AS subject_created_at,
    updated_at AS subject_updated_at,
    DATE(created_at) AS report_date
FROM dwh_bronze.subjects
WHERE deleted_at IS NULL;

ALTER TABLE dwh_silver.subjects_clean
    ADD INDEX idx_subjects_clean_subject_id (subject_id),
    ADD INDEX idx_subjects_clean_report_date (report_date),
    ADD INDEX idx_subjects_clean_semester_id (semester_id),
    ADD INDEX idx_subjects_clean_academic_year_id (academic_year_id),
    ADD INDEX idx_subjects_clean_category_id (category_id),
    ADD INDEX idx_subjects_clean_program_id (program_id);
