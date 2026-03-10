import pandas as pd
from sqlalchemy import text, inspect


def get_max_created_at(engine, table_name):
    """Return MAX(created_at) from the target table, or None if table doesn't exist."""
    insp = inspect(engine)
    if not insp.has_table(table_name):
        return None

    with engine.connect() as conn:
        row = conn.execute(
            text(f"SELECT MAX(created_at) FROM `{table_name}`")
        ).fetchone()

    return row[0] if row and row[0] is not None else None


def extract_card(engine, metabase_client, card_id, table_name, incremental_col):
    """
    Fetch card data from Metabase and apply incremental filtering.
    Returns a DataFrame of new rows only.
    """
    rows = metabase_client.get_card_data(card_id)

    if not rows:
        return pd.DataFrame()

    df = pd.DataFrame(rows)

    if incremental_col not in df.columns:
        return df

    df[incremental_col] = pd.to_datetime(df[incremental_col], errors="coerce")

    watermark = get_max_created_at(engine, table_name)
    if watermark is not None:
        watermark = pd.to_datetime(watermark)
        df = df[df[incremental_col] > watermark]

    return df
