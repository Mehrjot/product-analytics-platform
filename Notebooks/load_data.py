import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://root:root@localhost/product_analytics"
)

files = {
    "customers": "data/raw/olist_customers_dataset.csv",
    "orders": "data/raw/olist_orders_dataset.csv",
    "products": "data/raw/olist_products_dataset.csv",
    "payments": "data/raw/olist_order_payments_dataset.csv",
    "order_items": "data/raw/olist_order_items_dataset.csv"
}

for table, path in files.items():
    print(f"Importing {table}...")

    df = pd.read_csv(path)

    df.to_sql(
        table,
        con=engine,
        if_exists="replace",
        index=False
    )

    print(f"{table} imported: {len(df)} rows")

print("All tables imported successfully!")