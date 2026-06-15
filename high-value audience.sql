-- Query 4: Synthesize High-LTV Audience Profiles via Strict Business Thresholds
WITH Customer_Metrics AS (
  SELECT
    user_pseudo_id AS user_id,
    COUNT(DISTINCT ecommerce.transaction_id) AS total_purchases,
    SUM(ecommerce.purchase_revenue_in_usd) AS customer_lifetime_value
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_name = 'purchase'
    AND ecommerce.transaction_id IS NOT NULL
  GROUP BY
    user_id
)
SELECT
  user_id,
  total_purchases,
  ROUND(customer_lifetime_value, 2) AS lifetime_value,
  -- Add a clear segment tag for down-funnel CRM tools
  'HIGH_VALUE_CUSTOMER' AS audience_segment
FROM
  Customer_Metrics
WHERE
  -- Condition 1: Total lifetime contribution exceeds $150 USD
  customer_lifetime_value > 150.00
  -- Condition 2: Multi-buyers showing repeat purchasing traits
  OR total_purchases > 2
ORDER BY
  lifetime_value DESC;