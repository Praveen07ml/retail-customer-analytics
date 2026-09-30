from pathlib import Path
import pandas as pd

CLEAN = Path("../data/cleaned")

def calculate_kpis(transactions, returns):
    orders = transactions["transaction_id"].nunique()
    customers = transactions["customer_id"].nunique()
    revenue = transactions["total_amount"].sum()
    units = transactions["quantity"].sum()

    customer_orders = transactions.groupby("customer_id")["transaction_id"].nunique()
    repeat_purchase_rate = (customer_orders.ge(2).mean()
                            if len(customer_orders) else 0)

    return_orders = returns["transaction_id"].nunique()
    return_rate = return_orders / orders if orders else 0

    return {
        "orders": orders,
        "active_customers": customers,
        "revenue": revenue,
        "units_sold": units,
        "average_order_value": revenue / orders if orders else 0,
        "repeat_purchase_rate": repeat_purchase_rate,
        "return_order_rate": return_rate,
        "refund_amount": returns["return_amount"].sum()
    }

def main():
    tx = pd.read_csv(CLEAN/"transactions_clean.csv")
    returns = pd.read_csv(CLEAN/"returns_clean.csv")
    kpis = calculate_kpis(tx, returns)
    print("\nRetail KPI Summary")
    for key, value in kpis.items():
        print(f"{key:25s}: {value:,.2f}" if isinstance(value,(int,float)) else f"{key:25s}: {value}")

if __name__ == "__main__":
    main()
