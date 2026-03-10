CREATE DATABASE IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.users_clean;

CREATE TABLE silver.users_clean AS
SELECT
    id AS user_id,
    academic_year_id,
    associate_id,
    tablet_system_user_id,
    user_name,
    full_name,
    email,
    mobile,
    subscription_count,
    is_test_account,
    is_scholarship,
    is_vsp,
    complete_profile,
    is_converted,
    has_tablet,
    has_custom_course,
    has_wallet,
    mobile_verified_at,
    account_completed_at,
    last_login_at,
    created_at AS user_created_at,
    updated_at AS user_updated_at,
    DATE(created_at) AS report_date
FROM bronze.users
WHERE deleted_at IS NULL;

ALTER TABLE silver.users_clean
    ADD INDEX idx_users_clean_user_id (user_id),
    ADD INDEX idx_users_clean_report_date (report_date),
    ADD INDEX idx_users_clean_academic_year_id (academic_year_id),
    ADD INDEX idx_users_clean_associate_id (associate_id),
    ADD INDEX idx_users_clean_tablet_system_user_id (tablet_system_user_id(191));
