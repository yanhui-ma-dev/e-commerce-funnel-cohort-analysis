# calculate AOV
WITH session_orders AS (
  SELECT
    user_session,
    SUM(price) AS order_revenue
  FROM `still-mesh-488107-j5.cosmetics_data.all_events`
  WHERE event_type = 'purchase'
  GROUP BY user_session
)

SELECT
  COUNT(*) AS total_orders,
  SUM(order_revenue) AS total_revenue,
  SAFE_DIVIDE(SUM(order_revenue), COUNT(*)) AS AOV
FROM session_orders;