-- Query 3: Analyze Order Placement Frequency and Volume Profiles
SELECT
  user_pseudo_id AS user_id,
  COUNT(DISTINCT ecommerce.transaction_id) AS absolute_purchase_count,
  ROUND(AVG(ecommerce.purchase_revenue_in_usd), 2) AS average_order_value
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_name = 'purchase'
  AND ecommerce.transaction_id IS NOT NULL
GROUP BY
  user_id
ORDER BY
  absolute_purchase_count DESC, 
  average_order_value DESC;