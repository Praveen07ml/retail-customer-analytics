from pathlib import Path
import pandas as pd

RAW = Path("../data/raw")
CLEAN = Path("../data/cleaned")
CLEAN.mkdir(parents=True, exist_ok=True)

def clean_dates(df, columns):
    for col in columns:
        df[col] = pd.to_datetime(df[col], errors="coerce")
    return df

def clean_text(df, columns):
    for col in columns:
        if col in df.columns:
            df[col] = df[col].astype("string").str.strip()
            df[col] = df[col].replace({"": pd.NA, "nan": pd.NA, "None": pd.NA})
    return df

def main():
    customers = pd.read_csv(RAW/"customers.csv")
    transactions = pd.read_csv(RAW/"transactions.csv")
    products = pd.read_csv(RAW/"products.csv")
    stores = pd.read_csv(RAW/"stores.csv")
    returns = pd.read_csv(RAW/"returns.csv")
    campaigns = pd.read_csv(RAW/"campaigns.csv")
    loyalty = pd.read_csv(RAW/"loyalty.csv")

    customers = customers.drop_duplicates("customer_id")
    transactions = transactions.drop_duplicates("transaction_id")
    products = products.drop_duplicates("product_id")
    stores = stores.drop_duplicates("store_id")
    returns = returns.drop_duplicates("return_id")
    campaigns = campaigns.drop_duplicates("campaign_id")
    loyalty = loyalty.drop_duplicates("customer_id")

    customers = clean_text(customers, ["gender","city","state","customer_segment"])
    transactions = clean_text(transactions, ["payment_method"])
    products = clean_text(products, ["category","sub_category","brand"])
    stores = clean_text(stores, ["store_name","city","region","manager"])
    returns = clean_text(returns, ["return_reason"])
    campaigns = clean_text(campaigns, ["campaign_name","channel"])

    customers["city"] = customers["city"].fillna("Unknown")
    transactions["payment_method"] = transactions["payment_method"].fillna("Unknown")
    products["brand"] = products["brand"].fillna("Unknown")
    campaigns["channel"] = campaigns["channel"].fillna("Unknown")

    customers = clean_dates(customers, ["signup_date"])
    transactions = clean_dates(transactions, ["transaction_date"])
    returns = clean_dates(returns, ["return_date"])
    campaigns = clean_dates(campaigns, ["send_date"])
    loyalty = clean_dates(loyalty, ["last_activity_date"])

    # Recalculate total_amount to protect against source inconsistencies.
    transactions["total_amount"] = (
        transactions["quantity"] * transactions["unit_price"]
    ).round(2)

    # Keep only valid positive sales.
    transactions = transactions[
        (transactions["quantity"] > 0) &
        (transactions["unit_price"] >= 0)
    ].copy()

    # Referential integrity checks.
    transactions = transactions[
        transactions["customer_id"].isin(customers["customer_id"]) &
        transactions["product_id"].isin(products["product_id"]) &
        transactions["store_id"].isin(stores["store_id"])
    ].copy()

    for name, df in {
        "customers": customers,
        "transactions": transactions,
        "products": products,
        "stores": stores,
        "returns": returns,
        "campaigns": campaigns,
        "loyalty": loyalty
    }.items():
        df.to_csv(CLEAN/f"{name}_clean.csv", index=False)

    print("Cleaning complete.")
    print("Transactions:", len(transactions))
    print("Customers:", len(customers))

if __name__ == "__main__":
    main()
