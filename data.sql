-- Customers
INSERT INTO Customers (name, email, phone, city, state) VALUES
('Alice Johnson', 'alice@example.com', '555-1111', 'San Diego', 'CA'),
('Bob Smith', 'bob@example.com', '555-2222', 'Los Angeles', 'CA'),
('Charlie Brown', 'charlie@example.com', '555-3333', 'San Diego', 'CA');

-- Addresses
INSERT INTO CustomerAddresses (customer_id, address_line1, city, state, zip_code, is_primary) VALUES
(1, '123 Main St', 'San Diego', 'CA', '92101', TRUE),
(2, '456 Oak Ave', 'Los Angeles', 'CA', '90001', TRUE),
(3, '789 Pine Rd', 'San Diego', 'CA', '92102', TRUE);

-- Restaurants
INSERT INTO Restaurants (name, cuisine, city, state, rating, opening_time, closing_time) VALUES
('Taco Fiesta', 'Mexican', 'San Diego', 'CA', 4.5, '10:00', '22:00'),
('Pasta Palace', 'Italian', 'Los Angeles', 'CA', 4.2, '11:00', '23:00');

-- Menu Items
INSERT INTO MenuItems (restaurant_id, name, category, price, availability) VALUES
(1, 'Chicken Taco', 'Main', 5.99, TRUE),
(1, 'Beef Burrito', 'Main', 7.99, TRUE),
(2, 'Spaghetti Bolognese', 'Main', 12.50, TRUE),
(2, 'Fettuccine Alfredo', 'Main', 11.00, TRUE);

INSERT INTO Drivers (name, vehicle_type, city, state, rating, is_available) VALUES
('David Lee', 'Car', 'San Diego', 'CA', 4.8, TRUE),
('Eva Green', 'Bicycle', 'Los Angeles', 'CA', 4.5, TRUE);


-- Orders
INSERT INTO Orders (customer_id, restaurant_id, order_time, delivery_time, total_amount, status, special_instructions) VALUES
(1, 1, '2025-09-01 12:00', '2025-09-01 12:30', 13.98, 'delivered', 'Extra salsa'),
(2, 2, '2025-09-01 13:00', '2025-09-01 13:45', 23.50, 'delivered', 'No cheese'),
(3, 1, '2025-09-02 18:00', '2025-09-02 18:40', 5.99, 'delivered', '');

-- Order Items
INSERT INTO OrderItems (order_id, item_id, quantity, price) VALUES
(1, 1, 2, 11.98),
(1, 2, 1, 7.99),
(2, 3, 1, 12.50),
(2, 4, 1, 11.00),
(3, 1, 1, 5.99);


-- Deliveries
INSERT INTO Deliveries (order_id, driver_id, assigned_time, pickup_time, dropoff_time) VALUES
(1, 1, '2025-09-01 11:55', '2025-09-01 12:05', '2025-09-01 12:30'),
(2, 2, '2025-09-01 12:55', '2025-09-01 13:10', '2025-09-01 13:45'),
(3, 1, '2025-09-02 17:55', '2025-09-02 18:10', '2025-09-02 18:40');

-- Route Assignments
INSERT INTO RouteAssignments (driver_id, order_id, sequence_order, assigned_at) VALUES
(1, 1, 1, '2025-09-01 11:55'),
(2, 2, 1, '2025-09-01 12:55'),
(1, 3, 2, '2025-09-02 17:55');


INSERT INTO Payments (order_id, payment_type, amount, status) VALUES
(1, 'card', 13.98, 'completed'),
(2, 'wallet', 23.50, 'completed'),
(3, 'cash', 5.99, 'completed');

-- Reviews
INSERT INTO Reviews (customer_id, restaurant_id, driver_id, rating, comment) VALUES
(1, 1, 1, 5.0, 'Fast delivery!'),
(2, 2, 2, 4.5, 'Good food, on time'),
(3, 1, 1, 4.0, 'Tasty tacos');

-- Driver Ratings
INSERT INTO DriverRatings (driver_id, customer_id, rating, comment) VALUES
(1, 1, 5.0, 'Very punctual'),
(2, 2, 4.5, 'Friendly delivery'),
(1, 3, 4.0, 'Quick service');


INSERT INTO AnalyticsOrders (order_id, delivery_time_minutes, order_hour, day_of_week) VALUES
(1, 30, 12, 1),
(2, 45, 13, 1),
(3, 40, 18, 2);

INSERT INTO AnalyticsDrivers (driver_id, avg_delivery_time_minutes, deliveries_count, rating) VALUES
(1, 35, 2, 4.5),
(2, 45, 1, 4.5);

INSERT INTO AnalyticsRevenue (date, total_revenue, total_orders, total_commission) VALUES
('2025-09-01', 37.48, 2, 5.00),
('2025-09-02', 5.99, 1, 1.00);

INSERT INTO AnalyticsCustomerRetention (customer_id, order_count, last_order_date) VALUES
(1, 1, '2025-09-01'),
(2, 1, '2025-09-01'),
(3, 1, '2025-09-02');
