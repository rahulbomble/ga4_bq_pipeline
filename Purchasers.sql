-- Query 1: Isolate Distinct Purchasing Users with Basic Transaction Metadata
SELECT
  user_pseudo_id AS user_id,
  PARSE_DATE('%Y%m%d', event_date) AS transaction_date,
  ecommerce.transaction_id AS order_id,
  ecommerce.purchase_revenue_in_usd AS order_revenue
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_name = 'purchase'
  -- Exclude testing or empty revenue rows to ensure data integrity
  AND ecommerce.transaction_id IS NOT NULL 
  AND ecommerce.transaction_id != '(not set)'
ORDER BY
  transaction_date DESC;