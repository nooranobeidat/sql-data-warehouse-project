CREATE DATABASE IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.files_clean;

CREATE TABLE silver.files_clean AS
SELECT
    id AS file_id,
    subject_id,
    teacher_id,
    category_id,
    subcategory_id,
    file_type_id,
    course_id,
    program_id,
    academic_year_id,
    created_by,
    url,
    downloads,
    lunch_on,
    privacy,
    status AS file_status,
    visibility_status,
    is_exam,
    is_revision,
    is_updated,
    created_at AS file_created_at,
    updated_at AS file_updated_at,
    DATE(created_at) AS report_date
FROM bronze.files
WHERE deleted_at IS NULL;

ALTER TABLE silver.files_clean
    ADD INDEX idx_files_clean_file_id (file_id),
    ADD INDEX idx_files_clean_report_date (report_date),
    ADD INDEX idx_files_clean_subject_id (subject_id),
    ADD INDEX idx_files_clean_teacher_id (teacher_id),
    ADD INDEX idx_files_clean_category_id (category_id),
    ADD INDEX idx_files_clean_subcategory_id (subcategory_id(191)),
    ADD INDEX idx_files_clean_file_type_id (file_type_id),
    ADD INDEX idx_files_clean_course_id (course_id),
    ADD INDEX idx_files_clean_program_id (program_id),
    ADD INDEX idx_files_clean_academic_year_id (academic_year_id),
    ADD INDEX idx_files_clean_created_by (created_by);
