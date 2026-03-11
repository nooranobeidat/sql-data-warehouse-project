CREATE DATABASE IF NOT EXISTS dwh_gold;

CREATE OR REPLACE VIEW dwh_gold.content_daily_report_formatted AS
SELECT
    report_date,
    total_courses,
    total_units,
    total_classes,
    total_files,
    enrollments,
    avg_enrollments_per_course,
    enrollment_growth
FROM dwh_gold.content_daily_report;
