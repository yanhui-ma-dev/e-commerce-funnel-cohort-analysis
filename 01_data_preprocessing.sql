# overview data and check missing value
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT user_id) AS unique_users,
  COUNT(DISTINCT product_id) AS unique_products,
  COUNT(DISTINCT category_id) AS unique_categories,
  COUNTIF(user_id IS NULL) AS missing_users,
  COUNTIF(product_id IS NULL) AS missing_products
FROM `still-mesh-488107-j5.cosmetics_data.all_events`