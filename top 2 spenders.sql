-- Query G: Isolate the Highest-Spending VIP Tier
WITH Customer_LTV AS (
  SELECT
    user_pseudo_id AS user_id,
    SUM(ecommerce.purchase_revenue_in_usd) AS revenue_pool
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_name = 'purchase'
  GROUP BY
    user_id
),
Percentiles AS (
  SELECT
    user_id,
    revenue_pool,
    PERCENT_RANK() OVER (ORDER BY revenue_pool ASC) AS relative_rank
  FROM
    Customer_LTV
)
SELECT
  user_id,
  ROUND(revenue_pool, 2) AS absolute_value
FROM
  Percentiles
WHERE
  relative_rank >= 0.98 -- Isolates top 2% of customers
ORDER BY
  absolute_value DESC;