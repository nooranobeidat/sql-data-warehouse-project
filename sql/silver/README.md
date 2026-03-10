# Silver Layer SQL

This folder contains the Silver-layer build scripts for the warehouse.

## Assumptions

- Source tables live in the `dwh_bronze` MySQL database.
- Target tables are created in the `dwh_silver` MySQL database.
- Each script rebuilds one Silver table from its Bronze source.

## Important MySQL Note

MySQL does not support `CREATE OR REPLACE TABLE`, so each script uses:

1. `DROP TABLE IF EXISTS dwh_silver.<table_name>`
2. `CREATE TABLE dwh_silver.<table_name> AS SELECT ...`
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

The scripts reference `dwh_bronze.<table>` as the source and build outputs in `dwh_silver.<table>`.

## Output

The scripts create these target tables in `dwh_silver`:

- `dwh_silver.orders_clean`
- `dwh_silver.invoices_clean`
- `dwh_silver.users_clean`
- `dwh_silver.courses_clean`
- `dwh_silver.units_clean`
- `dwh_silver.unit_classes_clean`
- `dwh_silver.user_courses_clean`
- `dwh_silver.subjects_clean`
- `dwh_silver.cards_clean`
- `dwh_silver.files_clean`
