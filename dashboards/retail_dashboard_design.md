# Retail Analytics BI Dashboard Design

## Global filters
- Date
- Region
- Store
- Product category
- Customer segment
- Loyalty tier
- Campaign channel

## Tab 1 — Executive Summary
### KPI cards
1. Total Revenue
2. Orders
3. Average Order Value
4. Active Customers
5. Repeat Purchase Rate
6. Return Rate
7. Refund Amount
8. Estimated Customer Lifetime Value

### Visuals
- Monthly revenue trend
- Revenue by region
- Revenue vs previous month
- Top 10 stores
- Revenue by category

### Management questions
- Are sales growing?
- Which regions/stores contribute most?
- Is customer repeat behavior improving?
- Are returns eroding revenue?

## Tab 2 — Customer Segmentation
### Visuals
- RFM segment distribution
- Revenue by RFM segment
- Customer count by segment
- Recency vs monetary scatter
- Frequency vs monetary scatter
- Loyalty tier vs revenue

### Actions
- Champions → VIP retention
- Loyal → cross-sell / upsell
- High Potential → nurture
- At Risk → win-back
- Hibernating → reactivation test

## Tab 3 — Product Performance
### Visuals
- Revenue by category/sub-category
- Units sold
- Gross margin proxy
- Top/bottom products
- Return rate by category
- Stock quantity vs sales velocity

### Questions
- Which categories generate revenue?
- Which products have high returns?
- Which products may need inventory attention?

## Tab 4 — Store Performance
### Visuals
- Revenue by store
- AOV by store
- Customers per store
- Revenue per customer
- Regional benchmark
- Store ranking table

### Benchmark methodology
Compare each store with the average of stores in the same region.

## Tab 5 — Returns & Refunds
### Visuals
- Return rate trend
- Refund amount trend
- Return reason distribution
- Return rate by category
- Return rate by store

### Questions
- Where are returns concentrated?
- Which reasons dominate?
- Are certain stores/categories consistently above benchmark?

## Tab 6 — Marketing Performance
### Visuals
- Campaign sends
- Response rate
- Cost per response
- Response rate by channel
- Response rate by campaign
- Revenue/customer after response where attribution is available

### Important limitation
The provided campaign table contains response and spend but not campaign-attributed sales. Therefore, do not call campaign response “revenue conversion” unless a transaction attribution window is added.

## KPI definitions
- Revenue = SUM(transaction total_amount)
- AOV = Revenue / distinct orders
- Repeat Purchase Rate = customers with >=2 orders / active customers
- Return Rate = returned orders / orders
- Refund Rate by value = refund amount / revenue
- Customer Lifetime Value = modeled estimate; document assumptions
- Campaign Response Rate = responses / sends

## Recommended layout
Top: KPI cards
Middle: trend + geographic/store/category views
Bottom: diagnostic tables and exception lists
