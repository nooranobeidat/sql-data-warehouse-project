CREATE DATABASE IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.invoices_clean;

CREATE TABLE silver.invoices_clean AS
SELECT
    id AS invoice_id,
    order_id,
    user_id,
    accounting_updater_user_id,
    imported_by_user_id,
    invoice_id AS related_invoice_id,
    user_name,
    phone,
    type AS invoice_type,
    amount AS invoice_amount,
    collected_amount,
    delivery_fee,
    status AS invoice_status,
    payment_method,
    due_date,
    received_date,
    note,
    is_upgraded,
    is_downgraded,
    created_at AS invoice_created_at,
    updated_at AS invoice_updated_at,
    DATE(created_at) AS report_date
FROM bronze.invoices
WHERE deleted_at IS NULL;

ALTER TABLE silver.invoices_clean
    ADD INDEX idx_invoices_clean_invoice_id (invoice_id),
    ADD INDEX idx_invoices_clean_report_date (report_date),
    ADD INDEX idx_invoices_clean_order_id (order_id),
    ADD INDEX idx_invoices_clean_user_id (user_id),
    ADD INDEX idx_invoices_clean_accounting_updater_user_id (accounting_updater_user_id),
    ADD INDEX idx_invoices_clean_imported_by_user_id (imported_by_user_id),
    ADD INDEX idx_invoices_clean_related_invoice_id (related_invoice_id);
