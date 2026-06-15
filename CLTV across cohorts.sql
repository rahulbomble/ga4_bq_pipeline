-- Query D: Calculate Customer Lifetime Value Metrics across Cohorts
SELECT
  COUNT(DISTINCT user_pseudo_id) AS global_customer_pool,
  ROUND(SUM(ecommerce.purchase_revenue_in_usd), 2) AS cumulative_value,
  ROUND(SUM(ecommerce.purchase_revenue_in_usd) / COUNT(DISTINCT user_pseudo_id), 2) AS blended_historical_cltv
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_name = 'purchase';