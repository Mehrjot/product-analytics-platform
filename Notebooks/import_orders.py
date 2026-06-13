import pandas as pd
from sqlalchemy import create_engine

username = "root"
password = "root"      # change if different
host = "localhost"
database = "product_analytics"

engine = create_engine(
    f"mysql+pymysql://{username}:{password}@{host}/{database}"
)

df = pd.read_csv(
    "data/raw/olist_orders_dataset.csv"
)

print("Orders Shape:", df.shape)

df.to_sql(
    "orders",
    con=engine,
    if_exists="replace",
    index=False
)

print("Orders imported successfully!")