-- Query C: Map Value Metrics to Traffic Channels to Evaluate Channel Performance
WITH User_Acquisition AS (
  SELECT
    user_pseudo_id AS user_id,
    traffic_source.source AS first_source,
    traffic_source.medium AS first_medium
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_name = 'session_start'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp ASC) = 1
),
User_Revenue AS (
  SELECT
    user_pseudo_id AS user_id,
    SUM(ecommerce.purchase_revenue_in_usd) AS total_spend
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_name = 'purchase'
  GROUP BY
    user_id
)
SELECT
  COALESCE(ua.first_source, '(direct)') AS source,
  COALESCE(ua.first_medium, '(none)') AS medium,
  COUNT(DISTINCT ur.user_id) AS unique_purchasers,
  ROUND(SUM(ur.total_spend), 2) AS gross_channel_revenue,
  ROUND(AVG(ur.total_spend), 2) AS channel_customer_quality_ltv
FROM
  User_Revenue ur
LEFT JOIN
  User_Acquisition ua ON ur.user_id = ua.user_id
GROUP BY
  source, medium
ORDER BY
  gross_channel_revenue DESC;