-- ====================================================================
-- PROJECT: E-COMMERCE RETAIL PERFORMANCE ANALYSIS
-- AUTHOR: Manish Kumar
-- PURPOSE: To extract strategic business insights from transactional data
-- ====================================================================

USE EcommerceDB;

-- --------------------------------------------------------------------
-- KPI 1: BASELINE BUSINESS HEALTH OVERVIEW
-- Calculates overall revenue, order volume, and Average Order Value (AOV)
-- --------------------------------------------------------------------
SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(i.price * i.quantity) AS total_revenue,
    ROUND(SUM(i.price * i.quantity) / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM Order_Items i
JOIN Orders o ON i.order_id = o.order_id
WHERE o.order_status = 'Delivered';


-- --------------------------------------------------------------------
-- KPI 2: PRODUCT CATEGORY PERFORMANCE RANKING
-- Identifies which product verticals drive the highest consumer demand
-- --------------------------------------------------------------------
SELECT 
    category,
    SUM(quantity) AS units_sold,
    SUM(price * quantity) AS total_revenue
FROM Order_Items i
JOIN Orders o ON i.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY category
ORDER BY total_revenue DESC;


-- --------------------------------------------------------------------
-- KPI 3: GEOGRAPHIC REGIONAL CONSUMER PERFORMANCE
-- Maps total transaction distribution and value across Indian states
-- --------------------------------------------------------------------
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


-- --------------------------------------------------------------------
-- KPI 4: ADVANCED REVENUE DYNAMICS (MONTH-OVER-MONTH GROWTH)
-- Utilizes CTEs and the LAG window function to assess growth trends
-- --------------------------------------------------------------------
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