# Silver Layer SQL

This folder contains the Silver-layer build scripts for the warehouse.

## Assumptions

- Source tables live in the `bronze` MySQL database.
- Target tables are created in the `silver` MySQL database.
- Each script rebuilds one Silver table from its Bronze source.

## Important MySQL Note

MySQL does not support `CREATE OR REPLACE TABLE`, so each script uses:

1. `DROP TABLE IF EXISTS silver.<table_name>`
2. `CREATE TABLE silver.<table_name> AS SELECT ...`
3. `ALTER TABLE ... ADD INDEX ...`

## Files

Run the scripts in this order:

1. `silver_users_clean.sql`
2. `silver_subjects_clean.sql`
3. `silver_courses_clean.sql`
4. `silver_units_clean.sql`
5. `silver_unit_classes_clean.sql`
6. `silver_orders_clean.sql`
7. `silver_invoices_clean.sql`
8. `silver_user_courses_clean.sql`
9. `silver_cards_clean.sql`
10. `silver_files_clean.sql`

## Example Execution

From MySQL:

```sql
SOURCE sql/silver/silver_users_clean.sql;
SOURCE sql/silver/silver_subjects_clean.sql;
SOURCE sql/silver/silver_courses_clean.sql;
```

Or from a shell:

```powershell
Get-ChildItem .\sql\silver\*.sql | Sort-Object Name | ForEach-Object {
  Write-Host "Running $($_.Name)"
}
```

## If Your Current Bronze Database Is `dwh_bronze`

The scripts currently reference `bronze.<table>` to match the Silver-layer design.

If your local raw tables are still in `dwh_bronze`, either:

- rename or copy the raw tables into a `bronze` database, or
- replace `bronze.` with `dwh_bronze.` before execution

## Output

The scripts create these target tables in `silver`:

- `silver.orders_clean`
- `silver.invoices_clean`
- `silver.users_clean`
- `silver.courses_clean`
- `silver.units_clean`
- `silver.unit_classes_clean`
- `silver.user_courses_clean`
- `silver.subjects_clean`
- `silver.cards_clean`
- `silver.files_clean`
