CREATE DATABASE IF NOT EXISTS dwh_silver;

DROP TABLE IF EXISTS dwh_silver.user_courses_clean;

CREATE TABLE dwh_silver.user_courses_clean AS
SELECT
    id AS user_course_id,
    user_id,
    course_id,
    transaction_id,
    event_id,
    status AS enrollment_status,
    is_with_interactive_course,
    active_for_student,
    is_pending_course,
    is_specific_classes,
    is_gift,
    gift_type,
    has_mokathafat_gift,
    has_campaign_gift,
    expiry_date,
    schedule_at,
    upselling,
    created_at AS enrollment_created_at,
    updated_at AS enrollment_updated_at,
    DATE(created_at) AS report_date
FROM dwh_bronze.user_courses
WHERE deleted_at IS NULL;

ALTER TABLE dwh_silver.user_courses_clean
    ADD INDEX idx_user_courses_clean_user_course_id (user_course_id),
    ADD INDEX idx_user_courses_clean_report_date (report_date),
    ADD INDEX idx_user_courses_clean_user_id (user_id),
    ADD INDEX idx_user_courses_clean_course_id (course_id),
    ADD INDEX idx_user_courses_clean_transaction_id (transaction_id),
    ADD INDEX idx_user_courses_clean_event_id (event_id(191));
