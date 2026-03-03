CREATE OR REPLACE VIEW `still-mesh-488107-j5.cosmetics_data.channel_profitability_view` AS

-- First calculate the revenue of each channel.
WITH channel_revenue AS (
  SELECT 
    channel,
    SUM(total_revenue) AS revenue
  FROM `still-mesh-488107-j5.cosmetics_data.channel_daily_funnel`
  GROUP BY channel
),

-- Simulate ROAS
channel_efficiency AS (
  SELECT
    channel,
    revenue,
    CASE 
      WHEN channel = 'Email' THEN 10.5 
      WHEN channel = 'Meta' THEN 4.2   
      WHEN channel = 'TikTok' THEN 3.1 
      WHEN channel = 'Instagram' THEN 3.8
      ELSE 4.0 
    END AS target_roas
  FROM channel_revenue
),

-- 
budget AS (
  SELECT
    channel,
    revenue / target_roas AS spend 
  FROM channel_efficiency
),

-- Calculate the channel's total revenue
channel_totals AS (
  SELECT 
    channel, 
    SUM(total_revenue) AS channel_total_rev 
  FROM `still-mesh-488107-j5.cosmetics_data.channel_daily_funnel`
  GROUP BY channel
),

-- Distributed to the brand layer
allocated AS (
  SELECT
    f.event_date,
    f.channel,
    f.brand,
    f.purchase_users,
    f.total_revenue,
    (b.spend * SAFE_DIVIDE(f.total_revenue, t.channel_total_rev)) AS allocated_spend
  FROM `still-mesh-488107-j5.cosmetics_data.channel_daily_funnel` f
  JOIN channel_totals t ON f.channel = t.channel
  JOIN budget b ON f.channel = b.channel
)

-- Generate final indicators
SELECT
  *,
  SAFE_DIVIDE(total_revenue, purchase_users) AS aov,
  SAFE_DIVIDE(allocated_spend, purchase_users) AS cac,
  SAFE_DIVIDE(total_revenue, allocated_spend) AS roas
FROM allocated;