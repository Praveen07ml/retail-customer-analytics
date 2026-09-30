# Data Dictionary

## customers
| Column | Type | Description |
|---|---|---|
| customer_id | string | Unique customer identifier |
| age | integer | Customer age |
| gender | string | Customer gender |
| city | string | Customer city |
| state | string | Customer state |
| signup_date | date | Customer registration date |
| customer_segment | string | Source customer segment; analytical RFM segment is generated separately |

## transactions
| Column | Type | Description |
|---|---|---|
| transaction_id | string | Unique transaction/order identifier |
| customer_id | string | Customer foreign key |
| product_id | string | Product foreign key |
| store_id | string | Store foreign key |
| transaction_date | date | Sale date |
| quantity | integer | Units sold |
| unit_price | decimal | Selling price per unit after discount |
| total_amount | decimal | quantity × unit_price |
| payment_method | string | Payment method |

## products
| Column | Type | Description |
|---|---|---|
| product_id | string | Unique product identifier |
| category | string | Product category |
| sub_category | string | Product sub-category |
| brand | string | Brand |
| cost_price | decimal | Unit cost |
| stock_quantity | integer | Available stock |

## stores
| Column | Type | Description |
|---|---|---|
| store_id | string | Unique store identifier |
| store_name | string | Store name |
| city | string | Store city |
| region | string | Business region |
| manager | string | Store manager |

## returns
| Column | Type | Description |
|---|---|---|
| return_id | string | Unique return identifier |
| transaction_id | string | Returned transaction |
| return_date | date | Return date |
| return_amount | decimal | Refund amount |
| return_reason | string | Reason for return |

## campaigns
| Column | Type | Description |
|---|---|---|
| campaign_id | string | Unique campaign send/event |
| customer_id | string | Target customer |
| campaign_name | string | Campaign name |
| channel | string | Communication channel |
| send_date | date | Campaign send date |
| response_flag | integer | 1=response, 0=no response |
| spend_amount | decimal | Campaign cost allocated to send |

## loyalty
| Column | Type | Description |
|---|---|---|
| customer_id | string | Customer identifier |
| loyalty_tier | string | Loyalty program tier |
| points_earned | integer | Points earned |
| points_redeemed | integer | Points redeemed |
| last_activity_date | date | Last loyalty activity |

## Derived fields
- R_score, F_score, M_score
- RFM_score
- segment
- recency_days
- estimated_clv
