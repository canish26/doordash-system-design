-- =====================================
-- 1️⃣ Customers & Accounts
-- =====================================
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE CustomerAddresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    is_primary BOOLEAN DEFAULT TRUE
);

CREATE TABLE CustomerPreferences (
    preference_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    cuisine VARCHAR(50),
    dietary_restrictions TEXT
);

CREATE TABLE CustomerRewards (
    reward_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    points INT DEFAULT 0,
    tier VARCHAR(20)
);

CREATE TABLE CustomerPaymentMethods (
    payment_method_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    card_number VARCHAR(20),
    card_type VARCHAR(20),
    wallet_balance DECIMAL(10,2) DEFAULT 0,
    is_default BOOLEAN DEFAULT TRUE
);

-- =====================================
-- 2️⃣ Restaurants & Menu
-- =====================================
CREATE TABLE Restaurants (
    restaurant_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    cuisine VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    rating DECIMAL(2,1) DEFAULT 0,
    opening_time TIME,
    closing_time TIME
);

CREATE TABLE MenuItems (
    item_id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    availability BOOLEAN DEFAULT TRUE
);

CREATE TABLE RestaurantReviews (
    review_id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    rating DECIMAL(2,1),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE RestaurantPromotions (
    promotion_id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE,
    promo_code VARCHAR(50),
    discount_percent INT,
    valid_from TIMESTAMP,
    valid_to TIMESTAMP
);

CREATE TABLE RestaurantInventory (
    inventory_id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE,
    item_id INT REFERENCES MenuItems(item_id) ON DELETE CASCADE,
    stock INT
);

-- =====================================
-- 3️⃣ Drivers & Fleet Management
-- =====================================
CREATE TABLE Drivers (
    driver_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    vehicle_type VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    rating DECIMAL(2,1) DEFAULT 0,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE DriverShifts (
    shift_id SERIAL PRIMARY KEY,
    driver_id INT REFERENCES Drivers(driver_id) ON DELETE CASCADE,
    shift_start TIMESTAMP,
    shift_end TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE DriverLocationTracking (
    tracking_id SERIAL PRIMARY KEY,
    driver_id INT REFERENCES Drivers(driver_id) ON DELETE CASCADE,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DriverIncentives (
    incentive_id SERIAL PRIMARY KEY,
    driver_id INT REFERENCES Drivers(driver_id) ON DELETE CASCADE,
    amount DECIMAL(10,2),
    reason TEXT,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DriverRatings (
    rating_id SERIAL PRIMARY KEY,
    driver_id INT REFERENCES Drivers(driver_id) ON DELETE CASCADE,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    rating DECIMAL(2,1),
    comment TEXT,
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- 4️⃣ Orders & Deliveries
-- =====================================
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    restaurant_id INT REFERENCES Restaurants(restaurant_id),
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_time TIMESTAMP,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) CHECK (status IN ('placed', 'confirmed', 'preparing', 'picked_up', 'delivering', 'delivered', 'cancelled')),
    special_instructions TEXT,
    promo_code VARCHAR(50)
);

CREATE TABLE OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    item_id INT REFERENCES MenuItems(item_id),
    quantity INT,
    price DECIMAL(10,2)
);

CREATE TABLE OrderStatusHistory (
    status_history_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    status VARCHAR(20),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Deliveries (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    driver_id INT REFERENCES Drivers(driver_id),
    assigned_time TIMESTAMP,
    pickup_time TIMESTAMP,
    dropoff_time TIMESTAMP
);

CREATE TABLE RouteAssignments (
    route_id SERIAL PRIMARY KEY,
    driver_id INT REFERENCES Drivers(driver_id),
    order_id INT REFERENCES Orders(order_id),
    sequence_order INT,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE BatchDeliveries (
    batch_id SERIAL PRIMARY KEY,
    driver_id INT REFERENCES Drivers(driver_id),
    batch_date DATE,
    status VARCHAR(20)
);

-- =====================================
-- 5️⃣ Payments & Financials
-- =====================================
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    payment_type VARCHAR(20) CHECK (payment_type IN ('card', 'cash', 'wallet')),
    amount DECIMAL(10,2),
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'completed'
);

CREATE TABLE Refunds (
    refund_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    amount DECIMAL(10,2),
    reason TEXT,
    refunded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE WalletTransactions (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    amount DECIMAL(10,2),
    type VARCHAR(20) CHECK (type IN ('credit', 'debit')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Commissions (
    commission_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    restaurant_id INT REFERENCES Restaurants(restaurant_id),
    driver_id INT REFERENCES Drivers(driver_id),
    commission_amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- 6️⃣ Promotions & Marketing
-- =====================================
CREATE TABLE Promotions (
    promotion_id SERIAL PRIMARY KEY,
    promo_code VARCHAR(50),
    discount_percent INT,
    valid_from TIMESTAMP,
    valid_to TIMESTAMP
);

CREATE TABLE CustomerPromotions (
    customer_promo_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    promotion_id INT REFERENCES Promotions(promotion_id),
    redeemed_at TIMESTAMP
);

CREATE TABLE Referrals (
    referral_id SERIAL PRIMARY KEY,
    referrer_id INT REFERENCES Customers(customer_id),
    referee_id INT REFERENCES Customers(customer_id),
    bonus_points INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE MarketingCampaigns (
    campaign_id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(100),
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    target_audience TEXT
);

-- =====================================
-- 7️⃣ Notifications & Support
-- =====================================
CREATE TABLE Notifications (
    notification_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    message TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'sent'
);

CREATE TABLE SupportTickets (
    ticket_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    order_id INT REFERENCES Orders(order_id),
    issue TEXT,
    status VARCHAR(20) DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

-- =====================================
-- 8️⃣ Reviews
-- =====================================
CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    restaurant_id INT REFERENCES Restaurants(restaurant_id),
    driver_id INT REFERENCES Drivers(driver_id),
    rating DECIMAL(2,1),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- 9️⃣ Analytics
-- =====================================
CREATE TABLE AnalyticsOrders (
    analytics_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    delivery_time_minutes DECIMAL(5,2),
    order_hour INT,
    day_of_week INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AnalyticsDrivers (
    analytics_id SERIAL PRIMARY KEY,
    driver_id INT REFERENCES Drivers(driver_id),
    avg_delivery_time_minutes DECIMAL(5,2),
    deliveries_count INT,
    rating DECIMAL(2,1),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AnalyticsRevenue (
    analytics_id SERIAL PRIMARY KEY,
    date DATE,
    total_revenue DECIMAL(12,2),
    total_orders INT,
    total_commission DECIMAL(12,2)
);

CREATE TABLE AnalyticsCustomerRetention (
    analytics_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    order_count INT,
    last_order_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- 10️⃣ Optional: ML Predictions
-- =====================================
CREATE TABLE MLPredictions (
    prediction_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    predicted_delivery_time_minutes DECIMAL(5,2),
    surge_pricing_factor DECIMAL(3,2),
    recommended_items TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


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
