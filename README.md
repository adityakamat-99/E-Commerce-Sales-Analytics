# E-Commerce Sales & Customer Analytics

## Project Objective
This project evaluates e-commerce performance by tracking over ₹576M in revenue across 10,000+ orders. The analysis combines deep SQL backend querying with an interactive Power BI frontend to identify high-value customers, regional performance, market basket combinations, and month-over-month growth.

## Dashboard Preview

### Revenue & Product Overview
(Dashboard/Ecom_dashboard_1.png)

### Demographics & Regional Performance
(Dashboard/Ecom_dashboard_2.png)

## Tech Stack
* **Backend Data Manipulation:** MySQL (CTEs, Window Functions, Self-Joins)
* **Frontend Visualization:** Power BI

## Repository Architecture
* **`SQL/views_setup.sql`**: Data modeling script that structures the raw tables into clean `vw_customers`, `vw_orders`, `vw_orderdetails`, and `vw_products` views for reporting[cite: 5].
* **`SQL/business_analysis.sql`**: Contains advanced queries handling Data Integrity Audits, Market Basket Analysis, MoM Revenue Growth, and Customer Retention intervals[cite: 6].
* **`Dashboard/Ecom Dashboard.pbix`**: The final interactive Power BI file.

## Key SQL & Business Insights
1. **Data Integrity & QA:** Built a conditional logic audit using CTEs to isolate order IDs where aggregated line-item totals did not match the final recorded order amounts[cite: 6].
2. **Market Basket Analysis:** Utilized self-joins and `GROUP_CONCAT` to identify the most frequent product combinations purchased in the same cart[cite: 6].
3. **Customer Retention Metrics:** Calculated the exact average days between a customer's first and second purchase using `LEAD()` window functions to inform targeted email marketing timelines[cite: 6].
4. **MoM Revenue Tracking:** Built an automated rolling tracker using the `LAG()` function to calculate month-over-month percentage growth[cite: 6].
5. **Visual Insights:** The Power BI dashboard revealed that while *Electronics* accounts for 30.7% of total volume, *Photography* drives the highest average revenue per category.
