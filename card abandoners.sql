-- Query F: Map Non-Purchasing Cart Additions for Re-engagement Campaigns
WITH Cart_Adders AS (
  SELECT DISTINCT user_pseudo_id AS user_id FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` WHERE event_name = 'add_to_cart'
),
Actual_Buyers AS (
  SELECT DISTINCT user_pseudo_id AS user_id FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` WHERE event_name = 'purchase'
)
SELECT
  ca.user_id,
  'LAPSED_CART_ADDER' AS targeted_marketing_action
FROM
  Cart_Adders ca
LEFT JOIN
  Actual_Buyers ab ON ca.user_id = ab.user_id
WHERE
  ab.user_id IS NULL; -- Isolates high-intent drop-offs