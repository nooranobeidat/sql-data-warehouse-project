import pandas as pd
from sqlalchemy import types

CHUNK_SIZE = 5000


def _dtype_map(series):
    """Map pandas dtype to a MySQL-friendly SQLAlchemy type."""
    if pd.api.types.is_integer_dtype(series):
        return types.BigInteger()
    if pd.api.types.is_float_dtype(series):
        return types.Float()
    if pd.api.types.is_bool_dtype(series):
        return types.Boolean()
    if pd.api.types.is_datetime64_any_dtype(series):
        return types.DateTime()
    return types.Text()


def load_dataframe(engine, df, table_name):
    """Append a DataFrame into the target MySQL table."""
    if df.empty:
        return 0

    dtype = {col: _dtype_map(df[col]) for col in df.columns}

    with engine.connect() as conn:
        df.to_sql(
            name=table_name,
            con=conn,
            if_exists="append",
            index=False,
            dtype=dtype,
            chunksize=CHUNK_SIZE,
        )
        conn.commit()

    return len(df)
