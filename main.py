import logging
from dotenv import load_dotenv

from config.cards_config import CARDS
from etl.db import get_engine, ensure_database
from etl.metabase_client import MetabaseClient
from etl.extract import extract_card
from etl.load import load_dataframe

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s  %(levelname)-8s  %(message)s",
)
log = logging.getLogger(__name__)


def run():
    load_dotenv()

    engine = get_engine()
    ensure_database(engine)

    client = MetabaseClient()
    client.ensure_authenticated()
    log.info("Authenticated with Metabase")

    for card in CARDS:
        card_id = card["card_id"]
        table_name = card["table_name"]
        inc_col = card["incremental_col"]

        log.info("Processing card %s -> %s", card_id, table_name)
        try:
            df = extract_card(engine, client, card_id, table_name, inc_col)

            if df.empty:
                log.info("  No new rows for %s", table_name)
                continue

            rows_loaded = load_dataframe(engine, df, table_name)
            log.info("  Loaded %d rows into %s", rows_loaded, table_name)

        except Exception:
            log.exception("  Failed to process card %s (%s)", card_id, table_name)

    log.info("ETL run complete")


if __name__ == "__main__":
    run()
