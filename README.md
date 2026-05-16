# E-Commerce Data Analytics Pipeline & Executive Performance Dashboard

## 🎯 Project Overview
This project establishes an end-to-end data analytics workflow mimicking a real-world enterprise scenario. Raw transactional data across distinct operational dimensions (Users, Orders, and Items) was ingested into a localized MySQL relational database, optimized via advanced analytical queries, and systematically structured into a business intelligence solution using Power BI. 

The primary objective of this project is to turn fragmented retail rows into interactive operational metrics that executive stakeholders can utilize to track financial performance, revenue trajectory, and regional consumer demand.

---

## 📊 Executive Dashboard Preview
![E-Commerce Sales Dashboard](dashboard_screenshot.png)

---

## 🛠️ Tech Stack & Technical Competencies
- **Database Management System:** MySQL Server (Relational Schema Design, Constraints, Keys)
- **Business Intelligence & Visualization:** Power BI Desktop
- **Data Querying & Scripting Languages:** SQL, DAX (Data Analysis Expressions)
- **Analytical Methods:** Relational Mapping, Common Table Expressions (CTEs), Window Functions, Data Aggregation, Structural Flat-File Modeling

---

## 🗂️ Relational Database Schema Design
To maintain database normalization and referential integrity, the dataset was structured around three core linked tables using strict Primary Key (`PRIMARY KEY`) and Foreign Key (`FOREIGN KEY`) constraints:

* **`Users` Table:** House demographic vectors (`user_id`, `join_date`, `city`, `state`).
* **`Orders` Table:** Captures specific customer transaction checkpoints (`order_id`, `user_id`, `order_date`, `order_status`). Linked to `Users` via `user_id`.
* **`Order_Items` Table:** Tracks granular product line item breakdowns (`item_id`, `order_id`, `product_id`, `category`, `price`, `quantity`). Linked to `Orders` via `order_id`.

---

## 💡 Core Business Insights Solved via SQL

The underlying business logic and metric extractions were formulated via advanced SQL scripts executed within MySQL Workbench. 

### 1. High-Level Financial Health (Baseline Aggregations)
*Business Goal:* Determine total store performance across key operational indicators including total volume, gross revenue, and financial value per individual ticket.
```sql
SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(i.price * i.quantity) AS total_revenue,
    ROUND(SUM(i.price * i.quantity) / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM Order_Items i
JOIN Orders o ON i.order_id = o.order_id
WHERE o.order_status = 'Delivered';

--------------------------------------------------------------------------------------------
2. Month-over-Month (MoM) Growth Analytics (CTEs & Window Functions)
Business Goal: Track systemic growth trends and revenue velocity over historical periods using dynamic back-looking functions.
WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(i.price * i.quantity) AS total_revenue
    FROM Orders o
    JOIN Order_Items i ON o.order_id = i.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY 1
)
SELECT 
    sales_month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY sales_month) AS previous_month_revenue,
    ROUND(((total_revenue - LAG(total_revenue) OVER (ORDER BY sales_month)) / 
           LAG(total_revenue) OVER (ORDER BY sales_month)) * 100, 2) AS mom_growth_pct
FROM MonthlySales;

---------------------------------------------------------------------------------------------
3. Geographic Regional Market Share (Multi-Table Joins)
Business Goal: Isolate and map regional consumption distribution across Indian states to identify key geographic hubs for targeted marketing allocation.
SELECT 
    u.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(i.price * i.quantity) AS total_revenue
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items i ON o.order_id = i.order_id
WHERE o.order_status = 'Delivered'
GROUP BY u.state
ORDER BY total_revenue DESC;
--------------------------------------------------------------------------------------------
🚀 Interactive BI Dashboard Implementations
To ensure optimal chart responsiveness and minimize rendering load-times, the data was converted into an optimized analytical framework using SQL aggregation pipelines prior to loading.

Executive KPI Matrix: Constructed standalone dynamic card visuals for tracking overall scale, including gross revenue performance, volume count, and calculated Average Order Value (AOV) measures formatted in localized Indian Rupees (₹).

Geographic Market Share Visuals: Implemented interactive Treemaps that visualize revenue allocation across key regional customer bases (Delhi, Maharashtra, Karnataka, etc.) without information clutter.

Product Categorization Analysis: Utilized optimized horizontal clustered charts to rank inventory sales velocity by operational categories (Electronics, Apparel, Home Decor), indicating structural demand patterns.
-----------------------------------------------------------------------------------------------

📁 Repository Structure
├── database/
│   ├── users.csv                   # Synthetic customer demographic profiles 
│   ├── orders.csv                  # Transaction records and lifecycle statuses
│   └── order_items.csv             # Granular transaction item lists
├── scripts/
│   └── ecommerce_analysis.sql      # Production-ready SQL script with analytical queries
├── dashboard/
│   └── sales_performance.pbix       # Completed Power BI interactive file
├── dashboard_screenshot.png        # Rendered image preview of dashboard UI
└── README.md                       # Professional case-study documentation
