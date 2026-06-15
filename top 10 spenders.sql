-- Query A: Isolate the Elite Top 10% Revenue Tier via Analytical Windowing
WITH Total_Spend AS (
  SELECT
    user_pseudo_id AS user_id,
    SUM(ecommerce.purchase_revenue_in_usd) AS total_revenue
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_name = 'purchase'
    AND ecommerce.transaction_id IS NOT NULL
  GROUP BY
    user_id
),
Ranked_Customers AS (
  SELECT
    user_id,
    total_revenue,
    NTILE(10) OVER (ORDER BY total_revenue DESC) AS revenue_percentile_tier
  FROM
    Total_Spend
)
SELECT
  user_id,
  ROUND(total_revenue, 2) AS customer_spend
FROM
  Ranked_Customers
WHERE
  revenue_percentile_tier = 1; -- Selects top 10% bracket exclusively