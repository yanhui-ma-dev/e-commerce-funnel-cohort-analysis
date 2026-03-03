CREATE OR REPLACE TABLE `still-mesh-488107-j5.cosmetics_data.channel_daily_funnel` AS

WITH base AS (
  SELECT
    DATE(event_time) AS event_date,
    brand,
    user_id,
    event_type,
    price
  FROM `still-mesh-488107-j5.cosmetics_data.raw_events`
),

channel_assigned AS (
  SELECT
    *,
    CASE
      WHEN MOD(ABS(FARM_FINGERPRINT(CAST(user_id AS STRING))),100) < 40 THEN 'Meta'
      WHEN MOD(ABS(FARM_FINGERPRINT(CAST(user_id AS STRING))),100) < 70 THEN 'TikTok'
      WHEN MOD(ABS(FARM_FINGERPRINT(CAST(user_id AS STRING))),100) < 90 THEN 'Instagram'
      ELSE 'Email'
    END AS channel
  FROM base
),

behavior_adjusted AS (
  SELECT
    *,
    CASE
      WHEN event_type = 'purchase' THEN
        CASE
          WHEN channel = 'Meta' AND RAND() < 0.8 THEN 1
          WHEN channel = 'TikTok' AND RAND() < 0.4 THEN 1
          WHEN channel = 'Instagram' AND RAND() < 0.6 THEN 1
          WHEN channel = 'Email' AND RAND() < 0.9 THEN 1
          ELSE 0
        END
      ELSE 1
    END AS keep_event
  FROM channel_assigned
),

filtered AS (
  SELECT *
  FROM behavior_adjusted
  WHERE keep_event = 1
)

SELECT
  event_date,
  channel,
  brand,

  COUNT(DISTINCT IF(event_type='view', user_id, NULL)) AS view_users,
  COUNT(DISTINCT IF(event_type='cart', user_id, NULL)) AS cart_users,
  COUNT(DISTINCT IF(event_type='purchase', user_id, NULL)) AS purchase_users,

  SUM(
    IF(event_type='purchase',
      CASE
        WHEN channel = 'Meta' THEN price * 1.1
        WHEN channel = 'TikTok' THEN price * 0.9
        WHEN channel = 'Instagram' THEN price * 1.0
        WHEN channel = 'Email' THEN price * 1.2
      END,
    0)
  ) AS total_revenue,

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

FROM filtered
GROUP BY event_date, channel, brand
ORDER BY event_date, channel, brand;