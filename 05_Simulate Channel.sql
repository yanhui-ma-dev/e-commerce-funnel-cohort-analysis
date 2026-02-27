CREATE OR REPLACE TABLE `still-mesh-488107-j5.cosmetics_data.channel_daily_funnel` AS

WITH base AS (
  SELECT
    DATE(event_time) AS event_date,
    user_id,
    event_type
  FROM `still-mesh-488107-j5.cosmetics_data.raw_events`
),

-- For simulated channels
simulated_channel AS (
  SELECT
    *,
    CASE
      WHEN RAND() < 0.4 THEN 'Meta'
      WHEN RAND() < 0.7 THEN 'TikTok'
      WHEN RAND() < 0.9 THEN 'Instagram'
      ELSE 'Email'
    END AS channel
  FROM base
)

SELECT
  event_date,
  channel,
  COUNT(DISTINCT IF(event_type='view', user_id, NULL)) AS view,
  COUNT(DISTINCT IF(event_type='cart', user_id, NULL)) AS cart,
  COUNT(DISTINCT IF(event_type='purchase', user_id, NULL)) AS purchase,

  SAFE_DIVIDE(
    COUNT(DISTINCT IF(event_type='cart', user_id, NULL)),
    COUNT(DISTINCT IF(event_type='view', user_id, NULL))
  ) AS view_to_cart_rate,

  SAFE_DIVIDE(
    COUNT(DISTINCT IF(event_type='purchase', user_id, NULL)),
    COUNT(DISTINCT IF(event_type='cart', user_id, NULL))
  ) AS cart_to_purchase_rate,

  SAFE_DIVIDE(
    COUNT(DISTINCT IF(event_type='purchase', user_id, NULL)),
    COUNT(DISTINCT IF(event_type='view', user_id, NULL))
  ) AS view_to_purchase_rate

FROM simulated_channel
GROUP BY event_date, channel
ORDER BY event_date, channel;