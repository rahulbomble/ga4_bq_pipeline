-- Query B: Filter Baseline Transactions to Isolate Proven Repeat Buyers
SELECT
  user_pseudo_id AS user_id,
  COUNT(DISTINCT ecommerce.transaction_id) AS transactional_velocity
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_name = 'purchase'
GROUP BY
  user_id
HAVING
  transactional_velocity >= 2;