-- Query H: Build a Complete Recency, Frequency, and Monetary (RFM) Matrix
WITH Base_RFM AS (
  SELECT
    user_pseudo_id AS user_id,
    -- Recency calculation based on the newest date available in this dataset
    DATE_DIFF(DATE('2021-01-31'), MAX(PARSE_DATE('%Y%m%d', event_date)), DAY) AS recency_days,
    COUNT(DISTINCT ecommerce.transaction_id) AS frequency_count,
    SUM(ecommerce.purchase_revenue_in_usd) AS monetary_value
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_name = 'purchase'
  GROUP BY
    user_id
),
Scored_RFM AS (
  SELECT
    user_id,
    recency_days,
    frequency_count,
    monetary_value,
    -- Score calculations (1-5 scales)
    NTILE(5) OVER (ORDER BY recency_days ASC) AS recency_score, -- Lower recency means more active
    NTILE(5) OVER (ORDER BY frequency_count DESC) AS frequency_score,
    NTILE(5) OVER (ORDER BY monetary_value DESC) AS monetary_score
  FROM
    Base_RFM
)
SELECT
  user_id,
  recency_days,
  frequency_count,
  ROUND(monetary_value, 2) AS total_monetary_spend,
  (recency_score * 100 + frequency_score * 10 + monetary_score) AS rfm_combined_code,
  CASE
    WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'CHAMPIONS / ELITE'
    WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'AT RISK - NEED RETENTION'
    WHEN recency_score <= 1 THEN 'HIBERNATING / LOST'
    ELSE 'STANDARD CONVERTED CUSTOMER'
  END AS customer_lifecycle_status
FROM
  Scored_RFM;