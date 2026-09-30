from pathlib import Path
import numpy as np
import pandas as pd

CLEAN = Path("../data/cleaned")

def build_rfm(transactions, snapshot_date=None):
    tx = transactions.copy()
    tx["transaction_date"] = pd.to_datetime(tx["transaction_date"])

    if snapshot_date is None:
        snapshot_date = tx["transaction_date"].max() + pd.Timedelta(days=1)
    else:
        snapshot_date = pd.Timestamp(snapshot_date)

    rfm = (
        tx.groupby("customer_id")
          .agg(
              last_purchase_date=("transaction_date","max"),
              frequency=("transaction_id","nunique"),
              monetary=("total_amount","sum")
          )
          .reset_index()
    )

    rfm["recency_days"] = (snapshot_date - rfm["last_purchase_date"]).dt.days

    # Higher is better for all scores.
    rfm["R_score"] = pd.qcut(
        rfm["recency_days"].rank(method="first"),
        5, labels=[5,4,3,2,1]
    ).astype(int)

    rfm["F_score"] = pd.qcut(
        rfm["frequency"].rank(method="first"),
        5, labels=[1,2,3,4,5]
    ).astype(int)

    rfm["M_score"] = pd.qcut(
        rfm["monetary"].rank(method="first"),
        5, labels=[1,2,3,4,5]
    ).astype(int)

    rfm["RFM_score"] = (
        rfm["R_score"].astype(str) +
        rfm["F_score"].astype(str) +
        rfm["M_score"].astype(str)
    )

    def segment(row):
        r, f, m = row["R_score"], row["F_score"], row["M_score"]
        if r >= 4 and f >= 4 and m >= 4:
            return "Champions"
        if r >= 4 and f >= 3:
            return "Loyal Customers"
        if r >= 4 and m >= 4:
            return "High Potential"
        if r <= 2 and f >= 3:
            return "At Risk"
        if r <= 2 and f <= 2:
            return "Hibernating"
        if r >= 3 and f <= 2:
            return "New/Promising"
        return "Regular"

    rfm["segment"] = rfm.apply(segment, axis=1)
    return rfm

def build_clv(rfm, average_margin_rate=0.25, annual_purchase_frequency=None,
              retention_years=2):
    out = rfm.copy()
    if annual_purchase_frequency is None:
        annual_purchase_frequency = out["frequency"] / 1.0
    out["annual_revenue"] = out["monetary"] * annual_purchase_frequency / out["frequency"].clip(lower=1)
    out["annual_margin"] = out["annual_revenue"] * average_margin_rate
    out["estimated_clv"] = out["annual_margin"] * retention_years
    return out

def main():
    tx = pd.read_csv(CLEAN/"transactions_clean.csv")
    rfm = build_rfm(tx)
    rfm = build_clv(rfm)
    rfm.to_csv(CLEAN/"customer_rfm.csv", index=False)
    print(rfm["segment"].value_counts())
    print("RFM file created:", CLEAN/"customer_rfm.csv")

if __name__ == "__main__":
    main()
