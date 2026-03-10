CREATE DATABASE IF NOT EXISTS dwh_silver;

DROP TABLE IF EXISTS dwh_silver.orders_clean;

CREATE TABLE dwh_silver.orders_clean AS
SELECT
    id AS order_id,
    user_id,
    city_id,
    area_id,
    agent_id,
    delivery_id,
    campaign_id,
    category_id,
    field_id,
    semester_id,
    orderable_type,
    orderable_id,
    name AS order_name,
    primary_mobile,
    secondary_mobile,
    address,
    status AS order_status,
    type AS order_type,
    received_date,
    payment_method,
    total_amount,
    source,
    is_active,
    is_installment,
    is_upgraded,
    upgraded_amount,
    is_downgraded,
    downgraded_amount,
    write_off,
    created_at AS order_created_at,
    updated_at AS order_updated_at,
    DATE(created_at) AS report_date
FROM dwh_bronze.orders
WHERE deleted_at IS NULL
  AND status NOT IN (0, 4);

ALTER TABLE dwh_silver.orders_clean
    ADD INDEX idx_orders_clean_order_id (order_id),
    ADD INDEX idx_orders_clean_report_date (report_date),
    ADD INDEX idx_orders_clean_user_id (user_id),
    ADD INDEX idx_orders_clean_city_id (city_id),
    ADD INDEX idx_orders_clean_area_id (area_id),
    ADD INDEX idx_orders_clean_agent_id (agent_id),
    ADD INDEX idx_orders_clean_delivery_id (delivery_id(191)),
    ADD INDEX idx_orders_clean_campaign_id (campaign_id),
    ADD INDEX idx_orders_clean_category_id (category_id),
    ADD INDEX idx_orders_clean_field_id (field_id),
    ADD INDEX idx_orders_clean_semester_id (semester_id),
    ADD INDEX idx_orders_clean_orderable_id (orderable_id);
