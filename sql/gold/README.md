# Gold Layer SQL

This folder contains the Gold-layer daily reporting scripts for the warehouse.

## Assumptions

- Source tables live in the `dwh_silver` MySQL database.
- Target tables are created in the `dwh_gold` MySQL database.
- Each script rebuilds one Gold reporting table from Silver aggregates.

## Important MySQL Note

MySQL does not support `CREATE OR REPLACE TABLE` for tables, so each script uses:

1. `CREATE DATABASE IF NOT EXISTS dwh_gold`
2. `DROP TABLE IF EXISTS dwh_gold.<table_name>`
3. `CREATE TABLE dwh_gold.<table_name> AS SELECT ...`

## Create `dwh_gold`

The scripts create `dwh_gold` automatically, but you can also create it manually:

```sql
CREATE DATABASE IF NOT EXISTS dwh_gold;
```

## Run Order

Run the scripts in this order:

1. `gold_sales_daily_report.sql`
2. `gold_financial_daily_report.sql`
3. `gold_marketing_daily_report.sql`
4. `gold_content_daily_report.sql`

## Example Execution

From the MySQL client:

```sql
SOURCE sql/gold/gold_sales_daily_report.sql;
SOURCE sql/gold/gold_financial_daily_report.sql;
SOURCE sql/gold/gold_marketing_daily_report.sql;
SOURCE sql/gold/gold_content_daily_report.sql;
```

## Output

The scripts create these reporting tables in `dwh_gold`:

- `dwh_gold.financial_daily_report`
- `dwh_gold.sales_daily_report`
- `dwh_gold.marketing_daily_report`
- `dwh_gold.content_daily_report`
