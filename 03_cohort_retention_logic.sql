-- Step 3: Cohort Analysis with Retention Rate
WITH first_purchase AS (
  -- Each user's first purchase month
  SELECT
    user_id,
    MIN(DATE_TRUNC(event_time, MONTH)) AS cohort_month
  FROM `still-mesh-488107-j5.cosmetics_data.all_events`
  WHERE event_type = 'purchase'
  GROUP BY user_id
),
cohort_size AS (
  -- Total number of users per cohort
  SELECT
    cohort_month,
    COUNT(DISTINCT user_id) AS cohort_users
  FROM first_purchase
  GROUP BY cohort_month
),
user_activity AS (
  -- Number of active buyers per cohort per month
  SELECT
    u.cohort_month,
    DATE_TRUNC(e.event_time, MONTH) AS activity_month,
    COUNT(DISTINCT e.user_id) AS active_users
  FROM `still-mesh-488107-j5.cosmetics_data.all_events` e
  JOIN first_purchase u
    ON e.user_id = u.user_id
  WHERE e.event_type = 'purchase'
  GROUP BY u.cohort_month, DATE_TRUNC(e.event_time, MONTH)
)
SELECT
  ua.cohort_month,
  ua.activity_month,
  ua.active_users,
  cs.cohort_users,
  SAFE_DIVIDE(ua.active_users, cs.cohort_users) AS retention_rate,
  DATE_DIFF(
  DATE(ua.activity_month),
  DATE(ua.cohort_month),
  MONTH
) AS months_since_first_purchase
FROM user_activity ua
JOIN cohort_size cs
  ON ua.cohort_month = cs.cohort_month
ORDER BY cohort_month, activity_month;