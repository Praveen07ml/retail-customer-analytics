-- =========================================================
-- Retail Analytics SQL Query Pack | PostgreSQL
-- =========================================================

-- 1. Executive KPIs
SELECT
    COUNT(DISTINCT transaction_id) AS orders,
    COUNT(DISTINCT customer_id) AS active_customers,
    SUM(total_amount) AS gross_revenue,
    AVG(total_amount) AS average_order_value,
    SUM(quantity) AS units_sold
FROM fact_transactions;

-- 2. Revenue by region
SELECT
    s.region,
    SUM(t.total_amount) AS revenue,
    COUNT(DISTINCT t.transaction_id) AS orders,
    AVG(t.total_amount) AS aov
FROM fact_transactions t
JOIN dim_stores s ON t.store_id = s.store_id
GROUP BY s.region
ORDER BY revenue DESC;

-- 3. Store benchmarking
WITH store_metrics AS (
    SELECT
        s.store_id,
        s.store_name,
        s.region,
        SUM(t.total_amount) AS revenue,
        COUNT(DISTINCT t.transaction_id) AS orders,
        COUNT(DISTINCT t.customer_id) AS customers,
        SUM(t.quantity) AS units
    FROM fact_transactions t
    JOIN dim_stores s ON t.store_id = s.store_id
    GROUP BY s.store_id, s.store_name, s.region
)
SELECT *,
       revenue / NULLIF(customers,0) AS revenue_per_customer,
       revenue / NULLIF(orders,0) AS aov
FROM store_metrics
ORDER BY revenue DESC;

-- 4. Product/category performance
SELECT
    p.category,
    p.sub_category,
    SUM(t.total_amount) AS revenue,
    SUM(t.quantity) AS units,
    COUNT(DISTINCT t.transaction_id) AS orders,
    SUM(t.total_amount - (t.quantity * p.cost_price)) AS gross_margin
FROM fact_transactions t
JOIN dim_products p ON t.product_id = p.product_id
GROUP BY p.category, p.sub_category
ORDER BY revenue DESC;

-- 5. Repeat purchase rate
WITH customer_orders AS (
    SELECT customer_id, COUNT(DISTINCT transaction_id) AS orders
    FROM fact_transactions
    GROUP BY customer_id
)
SELECT
    COUNT(*) FILTER (WHERE orders >= 2)::NUMERIC / COUNT(*) AS repeat_purchase_rate
FROM customer_orders;

-- 6. Top customers by revenue
SELECT
    customer_id,
    COUNT(DISTINCT transaction_id) AS orders,
    SUM(total_amount) AS revenue,
    AVG(total_amount) AS aov
FROM fact_transactions
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 20;

-- 7. Return rate and refund amount
SELECT
    COUNT(DISTINCT r.transaction_id)::NUMERIC /
        NULLIF(COUNT(DISTINCT t.transaction_id),0) AS return_order_rate,
    SUM(r.return_amount) AS refund_amount
FROM fact_transactions t
LEFT JOIN fact_returns r ON t.transaction_id = r.transaction_id;

-- 8. Return analysis by product category
SELECT
    p.category,
    COUNT(DISTINCT t.transaction_id) AS orders,
    COUNT(DISTINCT r.transaction_id) AS returned_orders,
    COUNT(DISTINCT r.transaction_id)::NUMERIC /
        NULLIF(COUNT(DISTINCT t.transaction_id),0) AS return_rate,
    SUM(r.return_amount) AS refunds
FROM fact_transactions t
JOIN dim_products p ON t.product_id = p.product_id
LEFT JOIN fact_returns r ON t.transaction_id = r.transaction_id
GROUP BY p.category
ORDER BY return_rate DESC;

-- 9. Campaign conversion by channel
SELECT
    channel,
    COUNT(*) AS sends,
    SUM(response_flag) AS responses,
    AVG(response_flag::NUMERIC) AS response_rate,
    SUM(spend_amount) AS campaign_spend,
    SUM(spend_amount) / NULLIF(SUM(response_flag),0) AS cost_per_response
FROM fact_campaigns
GROUP BY channel
ORDER BY response_rate DESC;

-- 10. Customer RFM base table
WITH customer_metrics AS (
    SELECT
        customer_id,
        CURRENT_DATE - MAX(transaction_date) AS recency_days,
        COUNT(DISTINCT transaction_id) AS frequency,
        SUM(total_amount) AS monetary
    FROM fact_transactions
    GROUP BY customer_id
)
SELECT *,
       NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
       NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
       NTILE(5) OVER (ORDER BY monetary) AS monetary_score
FROM customer_metrics;

-- 11. High-value customer segment
WITH customer_revenue AS (
    SELECT customer_id, SUM(total_amount) AS revenue
    FROM fact_transactions
    GROUP BY customer_id
),
thresholds AS (
    SELECT percentile_cont(0.90) WITHIN GROUP (ORDER BY revenue) AS p90
    FROM customer_revenue
)
SELECT c.customer_id, c.revenue
FROM customer_revenue c
CROSS JOIN thresholds t
WHERE c.revenue >= t.p90
ORDER BY c.revenue DESC;

-- 12. Monthly revenue trend
SELECT
    DATE_TRUNC('month', transaction_date)::DATE AS month,
    SUM(total_amount) AS revenue,
    COUNT(DISTINCT transaction_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers
FROM fact_transactions
GROUP BY 1
ORDER BY 1;

-- 13. Payment method mix
SELECT
    COALESCE(payment_method,'Unknown') AS payment_method,
    SUM(total_amount) AS revenue,
    COUNT(DISTINCT transaction_id) AS orders
FROM fact_transactions
GROUP BY 1
ORDER BY revenue DESC;
