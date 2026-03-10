CREATE DATABASE IF NOT EXISTS dwh_silver;

DROP TABLE IF EXISTS dwh_silver.courses_clean;

CREATE TABLE dwh_silver.courses_clean AS
SELECT
    id AS course_id,
    category_id,
    academic_year_id,
    subject_id,
    program_id,
    teacher_id,
    price_id,
    bulk_id,
    expiry_date_id,
    name AS course_name,
    slug,
    type AS course_type,
    course_classification,
    package_classification,
    status AS course_status,
    is_full_course,
    is_center,
    can_show_on_web,
    allow_to_buy_from_web,
    allow_installment,
    created_at AS course_created_at,
    updated_at AS course_updated_at,
    DATE(created_at) AS report_date
FROM dwh_bronze.courses
WHERE deleted_at IS NULL;

ALTER TABLE dwh_silver.courses_clean
    ADD INDEX idx_courses_clean_course_id (course_id),
    ADD INDEX idx_courses_clean_report_date (report_date),
    ADD INDEX idx_courses_clean_category_id (category_id),
    ADD INDEX idx_courses_clean_academic_year_id (academic_year_id),
    ADD INDEX idx_courses_clean_subject_id (subject_id),
    ADD INDEX idx_courses_clean_program_id (program_id),
    ADD INDEX idx_courses_clean_teacher_id (teacher_id),
    ADD INDEX idx_courses_clean_price_id (price_id),
    ADD INDEX idx_courses_clean_bulk_id (bulk_id),
    ADD INDEX idx_courses_clean_expiry_date_id (expiry_date_id);
