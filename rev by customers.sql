-- Query 2: Compute Total Accumulated Value Generated per Unique User Profile
SELECT
  user_pseudo_id AS user_id,
  COUNT(DISTINCT ecommerce.transaction_id) AS total_orders,
  ROUND(SUM(ecommerce.purchase_revenue_in_usd), 2) AS lifetime_revenue
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_name = 'purchase'
  AND ecommerce.transaction_id IS NOT NULL
GROUP BY
  user_id
ORDER BY
  lifetime_revenue DESC;