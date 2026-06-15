-- Query E: Build a High-LTV Target Audience Enriched with Acquisition Source
WITH High_Value_Base AS (
  SELECT
    user_pseudo_id AS user_id,
    SUM(ecommerce.purchase_revenue_in_usd) AS aggregate_spend
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_name = 'purchase'
  GROUP BY
    user_id
  HAVING
    aggregate_spend > 200.00
),
Acquisition_Context AS (
  SELECT
    user_pseudo_id AS user_id,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_name = 'first_open' OR event_name = 'session_start'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp ASC) = 1
)
SELECT
  hvb.user_id,
  ROUND(hvb.aggregate_spend, 2) AS lifetime_value,
  ac.source,
  ac.medium,
  ac.campaign
FROM
  High_Value_Base hvb
INNER JOIN
  Acquisition_Context ac ON hvb.user_id = ac.user_id;