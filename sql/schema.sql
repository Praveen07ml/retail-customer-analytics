DROP TABLE IF EXISTS fact_campaigns, fact_returns, fact_transactions, dim_loyalty,
dim_customers, dim_products, dim_stores CASCADE;

CREATE TABLE dim_customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    age INT CHECK (age BETWEEN 18 AND 100),
    gender VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    signup_date DATE,
    customer_segment VARCHAR(30)
);

CREATE TABLE dim_products (
    product_id VARCHAR(10) PRIMARY KEY,
    category VARCHAR(100),
    sub_category VARCHAR(100),
    brand VARCHAR(100),
    cost_price NUMERIC(12,2),
    stock_quantity INT
);

CREATE TABLE dim_stores (
    store_id VARCHAR(10) PRIMARY KEY,
    store_name VARCHAR(150),
    city VARCHAR(100),
    region VARCHAR(50),
    manager VARCHAR(100)
);

CREATE TABLE dim_loyalty (
    customer_id VARCHAR(10) PRIMARY KEY REFERENCES dim_customers(customer_id),
    loyalty_tier VARCHAR(30),
    points_earned INT,
    points_redeemed INT,
    last_activity_date DATE
);

CREATE TABLE fact_transactions (
    transaction_id VARCHAR(12) PRIMARY KEY,
    customer_id VARCHAR(10) REFERENCES dim_customers(customer_id),
    product_id VARCHAR(10) REFERENCES dim_products(product_id),
    store_id VARCHAR(10) REFERENCES dim_stores(store_id),
    transaction_date DATE,
    quantity INT CHECK (quantity > 0),
    unit_price NUMERIC(12,2),
    total_amount NUMERIC(14,2),
    payment_method VARCHAR(30)
);

CREATE TABLE fact_returns (
    return_id VARCHAR(12) PRIMARY KEY,
    transaction_id VARCHAR(12) REFERENCES fact_transactions(transaction_id),
    return_date DATE,
    return_amount NUMERIC(14,2),
    return_reason VARCHAR(100)
);

CREATE TABLE fact_campaigns (
    campaign_id VARCHAR(12) PRIMARY KEY,
    customer_id VARCHAR(10) REFERENCES dim_customers(customer_id),
    campaign_name VARCHAR(100),
    channel VARCHAR(50),
    send_date DATE,
    response_flag INT CHECK (response_flag IN (0,1)),
    spend_amount NUMERIC(12,2)
);

CREATE INDEX idx_txn_customer ON fact_transactions(customer_id);
CREATE INDEX idx_txn_date ON fact_transactions(transaction_date);
CREATE INDEX idx_txn_product ON fact_transactions(product_id);
CREATE INDEX idx_txn_store ON fact_transactions(store_id);
CREATE INDEX idx_returns_txn ON fact_returns(transaction_id);
CREATE INDEX idx_campaign_customer ON fact_campaigns(customer_id);
