# Retail Analytics End-to-End Portfolio Project

A realistic retail analytics project covering **SQL + Python + customer analytics + BI + business insights**.

## Project architecture

```text
retail_analytics_project/
├── data/
│   ├── raw/
│   │   ├── customers.csv
│   │   ├── transactions.csv
│   │   ├── products.csv
│   │   ├── stores.csv
│   │   ├── returns.csv
│   │   ├── campaigns.csv
│   │   └── loyalty.csv
│   └── cleaned/
├── sql/
│   ├── schema.sql
│   └── queries.sql
├── notebooks/
│   ├── retail_eda.ipynb
│   └── customer_segmentation.ipynb
├── scripts/
│   ├── data_cleaning.py
│   ├── feature_engineering.py
│   └── kpis.py
├── dashboards/
│   └── retail_dashboard_design.md
├── docs/
│   ├── project_overview.md
│   ├── data_dictionary.md
│   └── business_requirements.md
└── README.md
```

## Dataset scale
- 5,000 customers
- 250 products
- 24 stores
- ~40,000 transaction rows before cleaning
- 3,200 returns
- 12,000 campaign interactions
- 5,000 loyalty records

The raw files intentionally contain a small amount of duplicate/missing data so the cleaning pipeline demonstrates real-world data-quality work.

## Recommended execution order

### Step 1 — Inspect raw data
Open the CSV files and understand grain, keys, data types and relationships.

### Step 2 — Clean the data
From `scripts/`:

```bash
cd scripts
python data_cleaning.py
```

This writes cleaned files to `data/cleaned/`.

### Step 3 — Build customer features

```bash
python feature_engineering.py
```

This generates `data/cleaned/customer_rfm.csv`.

### Step 4 — Calculate KPIs

```bash
python kpis.py
```

### Step 5 — Load PostgreSQL
Create a PostgreSQL database and run:

```sql
\i sql/schema.sql
```

Then load the cleaned CSVs into the dimension/fact tables.

### Step 6 — Run analytics SQL
Use `sql/queries.sql` to calculate:
- revenue,
- AOV,
- repeat purchase rate,
- store/region performance,
- product performance,
- return rate,
- campaign response,
- RFM base metrics.

### Step 7 — Run notebooks
Open:
- `notebooks/retail_eda.ipynb`
- `notebooks/customer_segmentation.ipynb`

### Step 8 — Build BI dashboard
Use `dashboards/retail_dashboard_design.md` as the Power BI/Tableau specification.

## RFM methodology

### Recency
Days since the customer's most recent purchase.

### Frequency
Number of distinct transactions.

### Monetary
Total transaction revenue.

All three dimensions are scored from 1–5. Recency is reverse-scored so that a more recent customer receives a higher score.

### Example segments
- Champions
- Loyal Customers
- High Potential
- At Risk
- Hibernating
- New/Promising
- Regular

## CLV note
The project uses a transparent CLV proxy based on revenue, margin assumption and retention period. This is suitable for a portfolio project, but a production implementation should consider cohort retention, contribution margin, discounting, customer survival probability and acquisition cost.

## Important analytical caveat
Campaign response is not equivalent to campaign-attributed revenue. The source model has a response flag and spend amount but no transaction attribution key/window. A production marketing model should add campaign exposure/attribution logic.

## Portfolio presentation
When presenting this project in interviews, explain it as a business problem rather than a collection of tools:

**Business problem → data model → data quality → SQL metrics → customer segmentation → dashboard → decisions.**

## Suggested interview story
> I built an end-to-end retail analytics solution that integrates customer, transaction, product, store, return, loyalty and campaign data. I cleaned intentionally imperfect source data using Python, modeled the data into dimensions and facts in PostgreSQL, developed KPI and RFM logic, created a CLV proxy, and designed a six-tab BI dashboard focused on revenue, customers, products, stores, returns and marketing effectiveness.

