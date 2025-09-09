Customer Retention Trends

WITH monthly_orders AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', order_time) AS order_month,
        COUNT(*) AS orders_count
    FROM Orders
    WHERE status = 'delivered'
    GROUP BY customer_id, DATE_TRUNC('month', order_time)
),
first_orders AS (
    SELECT 
        customer_id,
        MIN(DATE_TRUNC('month', order_time)) AS first_order_month
    FROM Orders
    WHERE status = 'delivered'
    GROUP BY customer_id
)
SELECT 
    mo.order_month,
    COUNT(DISTINCT CASE WHEN mo.order_month = fo.first_order_month THEN mo.customer_id END) AS new_customers,
    COUNT(DISTINCT CASE WHEN mo.order_month > fo.first_order_month THEN mo.customer_id END) AS repeat_customers,
    ROUND(
        COUNT(DISTINCT CASE WHEN mo.order_month > fo.first_order_month THEN mo.customer_id END)::NUMERIC /
        NULLIF(COUNT(DISTINCT mo.customer_id),0) * 100, 2
    ) AS retention_rate_percent
FROM monthly_orders mo
JOIN first_orders fo ON mo.customer_id = fo.customer_id
GROUP BY mo.order_month
ORDER BY mo.order_month;

Peak Hours & Delivery Performance


WITH order_hours AS (
    SELECT 
        EXTRACT(HOUR FROM order_time) AS order_hour,
        COUNT(*) AS total_orders,
        AVG(EXTRACT(EPOCH FROM (delivery_time - order_time))/60) AS avg_delivery_minutes
    FROM Orders
    WHERE status = 'delivered'
    GROUP BY order_hour
)
SELECT 
    order_hour,
    total_orders,
    ROUND(avg_delivery_minutes, 2) AS avg_delivery_time
FROM order_hours
ORDER BY total_orders DESC;

Regional Demand Spikes

SELECT 
    c.city,
    c.state,
    DATE(o.order_time) AS order_date,
    COUNT(o.order_id) AS total_orders
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.status = 'delivered'
GROUP BY c.city, c.state, DATE(o.order_time)
ORDER BY total_orders DESC
LIMIT 20;

Driver Efficiency Analytics

WITH driver_stats AS (
    SELECT 
        d.driver_id,
        d.name AS driver_name,
        COUNT(del.delivery_id) AS deliveries_count,
        AVG(EXTRACT(EPOCH FROM (del.dropoff_time - del.pickup_time))/60) AS avg_delivery_minutes,
        AVG(dr.rating) AS avg_driver_rating
    FROM Deliveries del
    JOIN Drivers d ON del.driver_id = d.driver_id
    LEFT JOIN DriverRatings dr ON d.driver_id = dr.driver_id
    JOIN Orders o ON del.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY d.driver_id, d.name
)
SELECT *
FROM driver_stats
ORDER BY deliveries_count DESC, avg_delivery_minutes ASC;

Revenue & Commission Reports

WITH revenue_data AS (
    SELECT 
        DATE(o.order_time) AS order_date,
        SUM(o.total_amount) AS total_revenue,
        COUNT(o.order_id) AS total_orders,
        SUM(c.commission_amount) AS total_commission
    FROM Orders o
    LEFT JOIN Commissions c ON o.order_id = c.order_id
    WHERE o.status = 'delivered'
    GROUP BY DATE(o.order_time)
)
SELECT 
    order_date,
    total_revenue,
    total_orders,
    total_commission,
    ROUND(total_commission / NULLIF(total_revenue,0) * 100, 2) AS commission_percent
FROM revenue_data
ORDER BY order_date DESC;

Top-selling Menu Items per Region

SELECT r.city, mi.name AS menu_item, COUNT(oi.order_item_id) AS total_sold
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN MenuItems mi ON oi.item_id = mi.item_id
JOIN Restaurants r ON mi.restaurant_id = r.restaurant_id
WHERE o.status = 'delivered'
GROUP BY r.city, mi.name
ORDER BY total_sold DESC
LIMIT 20;

Surge Pricing Analysis

SELECT DATE(order_time) AS order_date,
       EXTRACT(HOUR FROM order_time) AS hour,
       AVG(mp.surge_pricing_factor) AS avg_surge
FROM Orders o
JOIN MLPredictions mp ON o.order_id = mp.order_id
WHERE o.status = 'delivered'
GROUP BY DATE(order_time), hour
ORDER BY avg_surge DESC;



