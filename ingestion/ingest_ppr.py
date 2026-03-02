import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import os
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Load environment variables from .env
load_dotenv()

RAW_FILE = "data/raw/ppr_all.csv"
TABLE_NAME = "bronze_ppr_raw"
SCHEMA = "bronze"

def get_engine():
    conn_str = (
        f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}"
        f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
    )
    return create_engine(conn_str)

def create_schema(engine):
    with engine.connect() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {SCHEMA}"))
        conn.commit()
    logger.info(f"Schema '{SCHEMA}' ready")

def load_csv() -> pd.DataFrame:
    logger.info(f"Reading {RAW_FILE}...")
    df = pd.read_csv(
        RAW_FILE,
        encoding="windows-1252",     # PPR uses this encoding
        low_memory=False
    )
    # Standardise column names: lowercase, underscores
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
        .str.replace("(", "")
        .str.replace(")", "")
    )
    logger.info(f"Loaded {len(df):,} rows, columns: {list(df.columns)}")
    return df

def ingest_to_bronze(df: pd.DataFrame, engine):
    logger.info(f"Loading to {SCHEMA}.{TABLE_NAME}...")
    df.to_sql(
        TABLE_NAME,
        engine,
        schema=SCHEMA,
        if_exists="replace",    # Replace table each run (idempotent)
        index=False,
        chunksize=5000           # Load in batches for large files
    )
    with engine.connect() as conn:
        count = conn.execute(text(f"SELECT COUNT(*) FROM {SCHEMA}.{TABLE_NAME}")).scalar()
    logger.info(f"✅ Loaded {count:,} rows into {SCHEMA}.{TABLE_NAME}")

if __name__ == "__main__":
    engine = get_engine()
    create_schema(engine)
    df = load_csv()
    ingest_to_bronze(df, engine)
    logger.info("🏁 Ingestion complete!")