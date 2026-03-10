import os
from urllib.parse import quote_plus

from sqlalchemy import create_engine, text


def get_engine():
    password = quote_plus(os.getenv("DB_PASS", ""))
    url = (
        f"mysql+mysqlconnector://{os.getenv('DB_USER')}:{password}"
        f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
    )
    return create_engine(
        url,
        echo=False,
        pool_pre_ping=True,
        pool_recycle=3600,
        connect_args={"connect_timeout": 300},
    )


def ensure_database(engine):
    db_name = os.getenv("DB_NAME")
    with engine.connect() as conn:
        conn.execute(text(f"CREATE DATABASE IF NOT EXISTS `{db_name}`"))
        conn.execute(text(f"USE `{db_name}`"))
        conn.commit()
