CREATE DATABASE IF NOT EXISTS dwh_gold;

DROP TABLE IF EXISTS dwh_gold.content_daily_report;

CREATE TABLE dwh_gold.content_daily_report AS
WITH daily_courses AS (
    SELECT
        report_date,
        COUNT(course_id) AS total_courses
    FROM dwh_silver.courses_clean
    GROUP BY report_date
),
daily_units AS (
    SELECT
        report_date,
        COUNT(unit_id) AS total_units
    FROM dwh_silver.units_clean
    GROUP BY report_date
),
daily_classes AS (
    SELECT
        report_date,
        COUNT(class_id) AS total_classes
    FROM dwh_silver.unit_classes_clean
    GROUP BY report_date
),
daily_files AS (
    SELECT
        report_date,
        COUNT(file_id) AS total_files
    FROM dwh_silver.files_clean
    GROUP BY report_date
),
daily_enrollments AS (
    SELECT
        report_date,
        COUNT(user_course_id) AS enrollments,
        COUNT(DISTINCT course_id) AS active_courses
    FROM dwh_silver.user_courses_clean
    GROUP BY report_date
),
all_dates AS (
    SELECT report_date FROM daily_courses
    UNION
    SELECT report_date FROM daily_units
    UNION
    SELECT report_date FROM daily_classes
    UNION
    SELECT report_date FROM daily_files
    UNION
    SELECT report_date FROM daily_enrollments
),
daily_content AS (
    SELECT
        d.report_date,
        COALESCE(c.total_courses, 0) AS total_courses,
        COALESCE(u.total_units, 0) AS total_units,
        COALESCE(cl.total_classes, 0) AS total_classes,
        COALESCE(f.total_files, 0) AS total_files,
        COALESCE(e.enrollments, 0) AS enrollments,
        COALESCE(e.active_courses, 0) AS active_courses
    FROM all_dates AS d
    LEFT JOIN daily_courses AS c
        ON d.report_date = c.report_date
    LEFT JOIN daily_units AS u
        ON d.report_date = u.report_date
    LEFT JOIN daily_classes AS cl
        ON d.report_date = cl.report_date
    LEFT JOIN daily_files AS f
        ON d.report_date = f.report_date
    LEFT JOIN daily_enrollments AS e
        ON d.report_date = e.report_date
),
growth_base AS (
    SELECT
        report_date,
        total_courses,
        total_units,
        total_classes,
        total_files,
        enrollments,
        CASE
            WHEN active_courses = 0 THEN NULL
            ELSE enrollments / active_courses
        END AS avg_enrollments_per_course,
        LAG(enrollments) OVER (ORDER BY report_date) AS previous_enrollments
    FROM daily_content
)
SELECT
    report_date,
    FORMAT(total_courses, 0) AS total_courses,
    FORMAT(total_units, 0) AS total_units,
    FORMAT(total_classes, 0) AS total_classes,
    FORMAT(total_files, 0) AS total_files,
    FORMAT(enrollments, 0) AS enrollments,
    FORMAT(avg_enrollments_per_course, 2) AS avg_enrollments_per_course,
    CONCAT(
        ROUND(
            CASE
                WHEN previous_enrollments IS NULL OR previous_enrollments = 0 THEN NULL
                ELSE (enrollments - previous_enrollments) / previous_enrollments
            END * 100,
            2
        ),
        ' %'
    ) AS enrollment_growth
FROM growth_base
ORDER BY report_date;
