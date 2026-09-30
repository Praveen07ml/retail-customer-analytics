# Business Requirements

## Stakeholders
- Head of Retail
- Regional Managers
- Store Managers
- CRM/Marketing Team
- Merchandising Team
- Finance/Operations Team

## Primary questions
1. How much revenue are we generating?
2. Which regions and stores drive performance?
3. Which customers generate the most value?
4. What percentage of customers are repeat buyers?
5. Which customers show signs of churn risk?
6. Which products/categories drive sales and margin proxy?
7. Which products/categories have elevated return rates?
8. Which campaign channels produce the highest response rate?
9. Does loyalty engagement correlate with customer value?
10. Which stores or regions are below benchmark?

## Functional requirements
- Dashboard must support date, region, store, category, segment and channel filters.
- KPI definitions must be consistent across SQL, Python and BI.
- Customer-level metrics must be drillable.
- Store performance must support peer benchmarking.
- Return metrics must distinguish order rate from refund value.
- Marketing response must not be presented as sales attribution without an attribution field.

## Data-quality requirements
- Primary keys must be unique.
- Foreign keys must resolve to dimension records.
- Dates must be parseable.
- Quantity must be positive.
- Monetary fields must be non-negative.
- Duplicate raw records must be removed.
- Missing categorical values must be explicitly handled.

## Success criteria
The final solution should allow a business user to identify:
- highest-value customer segments,
- underperforming stores,
- high-return products/categories,
- effective campaign channels,
- revenue trends and operational exceptions.
