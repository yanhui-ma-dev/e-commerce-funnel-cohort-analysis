-- Calculate the number of users in each stage
WITH funnel AS (
  SELECT
    COUNT(DISTINCT user_id) AS total_visitors #Automatically removes duplicates and ignores duplicate events.
  FROM `still-mesh-488107-j5.cosmetics_data.all_events`
),
view_stage AS (
  SELECT COUNT(DISTINCT user_id) AS viewers
  FROM `still-mesh-488107-j5.cosmetics_data.all_events`
  WHERE event_type='view'
),
cart_stage AS (
  SELECT COUNT(DISTINCT user_id) AS cart_adders
  FROM `still-mesh-488107-j5.cosmetics_data.all_events`
  WHERE event_type='cart'
),
purchase_stage AS (
  SELECT COUNT(DISTINCT user_id) AS buyers
  FROM `still-mesh-488107-j5.cosmetics_data.all_events`
  WHERE event_type='purchase'
)
SELECT
  f.total_visitors,
  v.viewers,
  c.cart_adders,
  p.buyers,
  SAFE_DIVIDE(v.viewers,f.total_visitors) AS view_rate,
  SAFE_DIVIDE(c.cart_adders,v.viewers) AS add_to_cart_rate,
  SAFE_DIVIDE(p.buyers,c.cart_adders) AS purchase_rate
FROM funnel f
CROSS JOIN view_stage v
CROSS JOIN cart_stage c
CROSS JOIN purchase_stage p