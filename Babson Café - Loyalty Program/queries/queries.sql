PRAGMA foreign_keys = ON;

-- =====================================================
-- 1. Business Question:
--    Find the top 3 best-selling products in the last month by quantity.
--
--    Why this matters:
--    Shows which menu items sell the most units so the café can plan inventory
--    and feature popular items in promotions.
--
--    Output:
--    item_id, item_name, total quantity sold in the last full month of data
--    (September 2025), sorted high to low, top 3.
-- =====================================================

SELECT
    mi.item_id,
    mi.item_name,
    SUM(oi.quantity) AS total_qty_sold
FROM Order_Items AS oi
JOIN Orders AS o
    ON oi.order_id = o.order_id
JOIN Menu_Items AS mi
    ON oi.item_id = mi.item_id
WHERE date('1899-12-30', '+' || o.order_datetime || ' days')
      >= DATE('2025-09-01')
  AND date('1899-12-30', '+' || o.order_datetime || ' days')
      <  DATE('2025-10-01')
GROUP BY
    mi.item_id,
    mi.item_name
ORDER BY
    total_qty_sold DESC
LIMIT 3;

-- =====================================================
-- 2. Business Question:
--    For each customer, compute total spend, order count, and average ticket value;
--    filter to those above average ticket value.
--
--    Why this matters:
--    Identifies high-value customers whose typical order size is higher than normal.
--    These customers are good candidates for loyalty perks or premium upsell offers.
--
--    Output:
--    customer_id, customer_name, total_spend (sum of order_total),
--    order_count (number of orders),
--    avg_ticket_value (total_spend / order_count),
--    only for customers whose avg_ticket_value is greater than the café-wide average ticket.
-- =====================================================

SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(o.order_total) AS total_spend,
    COUNT(*) AS order_count,
    ROUND( SUM(o.order_total) * 1.0 / COUNT(*), 2 ) AS avg_ticket_value
FROM Orders AS o
JOIN Customers AS c
    ON o.customer_id = c.customer_id
WHERE o.customer_id IS NOT NULL
GROUP BY
    c.customer_id,
    customer_name
HAVING
    (SUM(o.order_total) * 1.0 / COUNT(*)) >
    (
        SELECT AVG(order_total)
        FROM Orders
    )
ORDER BY
    avg_ticket_value DESC;

-- =====================================================
-- 3. Business Question:
--    By product category, compute revenue, cost, gross margin, and margin percentage.
--
--    Why this matters:
--    Shows which categories are driving profit, not just sales volume.
--    This helps with pricing, bundling, and deciding what to promote.
--
--    Output:
--    category,
--    total_revenue (sum of line_total),
--    total_cost (sum of unit cost * quantity),
--    gross_margin_dollars (revenue - cost),
--    gross_margin_pct (gross_margin_dollars / revenue * 100).
-- =====================================================

SELECT
    mi.category,
    ROUND(SUM(oi.line_total), 2) AS total_revenue,
    ROUND(SUM(mi.cost * oi.quantity), 2) AS total_cost,
    ROUND(SUM(oi.line_total) - SUM(mi.cost * oi.quantity), 2) AS gross_margin_dollars,
    ROUND(
        ( (SUM(oi.line_total) - SUM(mi.cost * oi.quantity))
          / NULLIF(SUM(oi.line_total), 0)
        ) * 100.0
    , 1) AS gross_margin_pct
FROM Order_Items AS oi
JOIN Orders AS o
    ON oi.order_id = o.order_id
JOIN Menu_Items AS mi
    ON oi.item_id = mi.item_id
GROUP BY
    mi.category
ORDER BY
    gross_margin_pct DESC;


-- =====================================================
-- 4. Business Question:
--    Identify customers with high points but no orders in the last 60 days
--    (re-engagement list).
--
--    Why this matters:
--    These customers have earned loyalty points in the past but recently
--    stopped purchasing. They are ideal targets for win-back campaigns.
--
--    Output:
--    customer_id, customer_name, loyalty_points.
--    We define "high points" as loyalty_points >= 50.
-- =====================================================

SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.loyalty_points
FROM Customers AS c
WHERE
    c.loyalty_points >= 50
    AND c.customer_id NOT IN (
        SELECT DISTINCT o.customer_id
        FROM Orders AS o
        WHERE o.customer_id IS NOT NULL
          AND date('1899-12-30', '+' || o.order_datetime || ' days')
                >= DATE('now','-60 days')
          AND date('1899-12-30', '+' || o.order_datetime || ' days')
                <= DATE('now')
    )
ORDER BY
    c.loyalty_points DESC;


-- =====================================================
-- 5. Business Question:
--    Show distribution of orders by payment method.
--
--    Why this matters:
--    Tells the café how customers prefer to pay (card, cash, mobile),
--    which helps with POS staffing, cash handling, and mobile adoption strategy.
--
--    Output:
--    payment_method, number of orders using that method,
--    and the percentage of total orders.
-- =====================================================

SELECT
    o.payment_method,
    COUNT(*) AS num_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders),
        1
    ) AS pct_of_orders
FROM Orders AS o
GROUP BY
    o.payment_method
ORDER BY
    num_orders DESC;


-- =====================================================
-- 6. Business Question:
--    Produce a monthly sales trend and identify the highest-revenue month.
--
--    Why this matters:
--    Shows which months drive the most money overall. This helps with forecasting,
--    staffing for peak periods, and planning promotions around strong months.
--
--    Output:
--    year_month (YYYY-MM),
--    monthly_revenue (sum of order_total for that month),
--    sorted by monthly_revenue from highest to lowest so the top row is the best month.
-- =====================================================

SELECT
    STRFTIME('%Y-%m', date('1899-12-30', '+' || o.order_datetime || ' days')) AS year_month,
    ROUND(SUM(o.order_total), 2) AS monthly_revenue
FROM Orders AS o
GROUP BY
    year_month
ORDER BY
    monthly_revenue DESC;


-- =====================================================
-- 7. Business Question (Original):
--    How do in-store orders compare to app orders in terms of volume and revenue?
--
--    Why this matters:
--    Shows how much business is coming from the app vs walk-in traffic.
--    This helps decide where to invest marketing (in-app promos vs in-store signage)
--    and how to staff/register for peak channels.
--
--    Output:
--    order_channel (for example 'in-store' or 'app'),
--    num_orders (how many orders came from that channel),
--    total_revenue (sum of order_total for that channel).
-- =====================================================

SELECT
    o.order_channel,
    COUNT(*) AS num_orders,
    ROUND(SUM(o.order_total), 2) AS total_revenue
FROM Orders AS o
GROUP BY
    o.order_channel
ORDER BY
    total_revenue DESC;


-- =====================================================
-- 8. Query Name: Employee Sales Performance
--    Business Question:
--    Which employees are responsible for the most total sales?
--
--    Why this matters:
--    Identifies top-performing employees. Management can use this information
--    for scheduling, recognition, and training.
--
--    Output:
--    employee_id, employee_name, role, total_sales_handled.
-- =====================================================

SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.role,
    ROUND(SUM(o.order_total), 2) AS total_sales_handled
FROM Orders AS o
JOIN Employees AS e
    ON o.employee_id = e.employee_id
GROUP BY
    e.employee_id,
    employee_name,
    e.role
ORDER BY
    total_sales_handled DESC;

