### E-commerce Funnel & Cohort Retention Analysis

## 📌 Project Overview
This project aims to analyze user behavior data from a mid-sized cosmetics e-commerce company over five timeframes. By constructing a marketing funnel and conducting cohort analysis, it identifies conversion bottlenecks and provides data support for improving customer lifetime value (LTV).

The project utilizes BigQuery to process millions of raw event data points and combines this with Python (Pandas/Seaborn) for advanced analysis and visualization.

## 🛠️ Tech Stack
Data Warehouse: Google BigQuery (SQL) - for large-scale data cleaning, metric aggregation, and cohort definition.

Programming: Python (Pandas, NumPy) - for matrix operations and refined analysis.

Visualization: Matplotlib, Seaborn - for creating funnel plots and retention heatmaps.

Environment: Google Colab.

Business Context & Metrics Definition

Goal: Increase overall conversion rate from visit to purchase.

# KPIs:

CR (Conversion Rate): \frac{\text{Unique Purchases}}{\text{Unique Visitors}}

Drop-off Rate: 1 - \frac{\text{Users at Stage} n}{\text{Users at Stage} n-1}

## 📊 Key Analysis & Insights

# 1. Overall Funnel Conversion
By tracking 1.639 million total visitors, a four-stage funnel from browsing to purchase was constructed.

Total Visitors: 1,639,358

Product Viewers: 1,597,754

Cart Adders: 398,308

Buyers: 110,518

# 📈 Funnel Visualizations
funnel_conversion_chart.png

#  Bottleneck Identification: The core bottlenecks lie in the Add-to-Cart stage (75.1% Churn Rate) and the Payment stage (72.3% Churn Rate), indicating significant friction or user hesitation in the checkout process.

# 2. Category & Brand Breakdown (Dimensional Analysis)
In-depth analysis of the Top 10 categories and brands identified anomalous market segments.

| Category ID | Brand | Viewers | Add-to-Cart Rate | Purchase Rate |
| :--- | :--- | :--- | :--- | :--- |
| 1602943681873052386 | grattol | 83,670 | 43.5% | 34.6% |
| 1487580013950664926 | None | 69,436 | 16.2% | 26.2% |
| 1487580013841613016 | kapous | 61,251 | 12.2% | 32.6% |
| 1487580005092295511 | None | 52,449 | 31,086 | 11,020 | 59.3% | 35.5% |
| 1487580008246412266 | None | 30,697 | 10,625 | 3,307 | 34.6% | 31.1% |
| 1487580005092295511 | uno | 30,421 | 15,417 | 5,732 | 50.7% | 37.2% |
| 1487580008246412266 | estel | 30,231 | 10,445 | 3,478 | 34.6% | 33.3% |
| 1487580005134238553 | runail | 27,225 | 20,807 | 6,465 | 76.4% | 31.1% |
| 1487580013841613016 | None | 26,483 | 6,844 | 1,867 | 25.8% | 27.3% |
| 1487580005092295511 | grattol | 22,136 | 13,324 | 3,933 | 60.2% | 29.5% |

# 📈 Category & Brand Dimensional Analysis Visualizations
category_viewers_vs_purchase_rate.png

Add_to_Car_ Drop_off_Rate_Heatmap.png

purchase_drop_off_rate_heatmap.png

# Insight: 
# High Interest, Low Purchase: Some high-traffic categories (e.g., Category ID ...95511) had an add-to-cart rate of 56.5%, but a low final purchase conversion rate.

Certain categories (ID ...13016) from "kapous" and categories (ID ...64926) from "None" were identified with a churn rate as high as 88% and 84% at the cart stage. 

Additionally, those two certain category IDs and categories (ID ...95511) from "grattol" were also identified with a churn rate as high as 70%-74% at the payment stage. 

# 3. Cohort Retention (User Behavior Analysis)
Segment users by their first purchase month and analyze retention patterns over time.

# Insights - Significant Decline in Early Retention

New users acquired in Nov and Dec 2019 showed a Month 1 retention of only 9.8% and 8.5%, a 47%-54% decrease compared to the 18.5% recorded for the Oct 2019 cohort.

Seasonal User Quality: While Q4 promotions drove high initial acquisition, the retention heatmap reveals that these holiday shoppers have lower long-term loyalty than standard-period users.


# 📈 Cohort Visualizations
cohort_retention_rate_heatmap.png

## 🚀 Actionable Recommendations Based on data insights, the following business optimization strategies are proposed:
Retargeting Strategy: Target categories with high add-to-cart but low conversion rates (e.g., categories with add-to-cart churn rate > 50%) with targeted advertising.

Optimize Payment Experience: Given the 72.3% churn rate at checkout, it is recommended to review the payment process, shipping fee settings, or simplify the registration process.

User Lifecycle Management: Create an automated "Welcome Email Series" for new users, focusing on optimizing first-month retention.

## 📂 Project Structure
Step 1: BigQuery SQL queries - Raw data cleaning and funnel model construction.
Step 2: Python Analysis - Category churn rate calculation and visualization.
Step 3: Cohort Matrix - Retention matrix generation and heatmap drawing.
