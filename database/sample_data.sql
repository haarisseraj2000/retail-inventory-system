-- Sample Data for Retail Inventory Management System
-- Run this after schema.sql to populate with more test data

USE retail_inventory;

-- Additional locations
INSERT INTO locations (name, address, city, state, zip_code, phone) VALUES 
('Downtown Branch', '789 Downtown Blvd', 'New York', 'NY', '10002', '555-0789'),
('Uptown Store', '456 Uptown Ave', 'New York', 'NY', '10003', '555-0456'),
('Warehouse A', '1000 Industrial Way', 'Brooklyn', 'NY', '11201', '555-1000');

-- Additional users
INSERT INTO users (username, email, password_hash, first_name, last_name, role) VALUES 
('manager1', 'manager1@retailstore.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE7GCJ4NGMcV7SkE6', 'John', 'Manager', 'MANAGER'),
('staff1', 'staff1@retailstore.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE7GCJ4NGMcV7SkE6', 'Sarah', 'Johnson', 'STAFF'),
('staff2', 'staff2@retailstore.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE7GCJ4NGMcV7SkE6', 'Mike', 'Wilson', 'STAFF');

-- Additional categories with subcategories
INSERT INTO categories (name, description, parent_category_id) VALUES 
('Smartphones', 'Mobile phones and accessories', 1),
('Laptops', 'Laptop computers and accessories', 1),
('Men Clothing', 'Mens apparel', 2),
('Women Clothing', 'Womens apparel', 2),
('Indoor Plants', 'House plants and accessories', 3),
('Garden Tools', 'Gardening equipment', 3),
('Fitness Equipment', 'Exercise and fitness gear', 4),
('Outdoor Gear', 'Camping and hiking equipment', 4);

-- Additional suppliers
INSERT INTO suppliers (name, contact_person, email, phone, address, city, state, zip_code, payment_terms) VALUES 
('Global Electronics', 'Alice Chen', 'alice@globalelectronics.com', '555-2000', '200 Tech Park', 'Austin', 'TX', '73301', 'Net 30'),
('Fashion Forward Inc.', 'Robert Davis', 'robert@fashionforward.com', '555-3000', '300 Fashion Ave', 'Los Angeles', 'CA', '90210', 'Net 15'),
('Home & Garden Supplies', 'Emma Thompson', 'emma@homegardens.com', '555-4000', '400 Green Way', 'Portland', 'OR', '97201', 'Net 30'),
('Sports Unlimited', 'David Brown', 'david@sportsunlimited.com', '555-5000', '500 Athletic Drive', 'Denver', 'CO', '80202', 'Net 45');

-- Additional products
INSERT INTO products (sku, name, description, category_id, supplier_id, barcode, unit_price, cost_price, min_stock_level, reorder_point) VALUES 
-- Electronics
('PHONE001', 'iPhone 14 Pro', 'Latest iPhone with Pro camera system', 6, 2, '123456789015', 999.99, 699.99, 10, 15),
('PHONE002', 'Samsung Galaxy S23', 'Premium Android smartphone', 6, 2, '123456789016', 899.99, 629.99, 12, 18),
('LAPTOP002', 'MacBook Air M2', 'Apple MacBook Air with M2 chip', 7, 2, '123456789017', 1199.99, 799.99, 8, 12),
('TABLET001', 'iPad Pro 12.9"', 'Professional tablet with M2 chip', 1, 2, '123456789018', 1099.99, 749.99, 6, 10),
('HEADPHONE001', 'AirPods Pro', 'Wireless earbuds with noise cancellation', 1, 2, '123456789019', 249.99, 149.99, 25, 35),

-- Clothing
('JEANS001', 'Mens Denim Jeans', 'Classic fit denim jeans', 8, 3, '123456789020', 79.99, 39.99, 30, 45),
('DRESS001', 'Womens Summer Dress', 'Floral print summer dress', 9, 3, '123456789021', 59.99, 29.99, 20, 30),
('JACKET001', 'Mens Leather Jacket', 'Genuine leather motorcycle jacket', 8, 3, '123456789022', 299.99, 179.99, 5, 8),
('SHOES001', 'Running Shoes', 'Professional running shoes', 2, 4, '123456789023', 129.99, 69.99, 40, 60),

-- Home & Garden
('PLANT001', 'Monstera Deliciosa', 'Popular indoor plant', 10, 4, '123456789024', 39.99, 19.99, 15, 25),
('SHOVEL001', 'Garden Spade', 'Heavy-duty garden spade', 11, 4, '123456789025', 49.99, 24.99, 10, 15),
('FERTILIZER001', 'Plant Food', 'All-purpose plant fertilizer', 3, 4, '123456789026', 19.99, 9.99, 50, 75),

-- Sports & Outdoors
('DUMBBELL001', 'Adjustable Dumbbells', 'Set of adjustable dumbbells 5-50lbs', 12, 5, '123456789027', 299.99, 179.99, 8, 12),
('TENT001', 'Camping Tent 4-Person', 'Waterproof family camping tent', 13, 5, '123456789028', 199.99, 119.99, 12, 18),
('BACKPACK001', 'Hiking Backpack', 'Professional hiking backpack 65L', 13, 5, '123456789029', 149.99, 89.99, 15, 22),

-- Books
('BOOK001', 'Programming in Java', 'Complete guide to Java programming', 5, NULL, '123456789030', 49.99, 24.99, 25, 40),
('BOOK002', 'Database Design', 'MySQL database design principles', 5, NULL, '123456789031', 39.99, 19.99, 20, 30);

-- Initial inventory for new products
INSERT INTO inventory_transactions (product_id, location_id, transaction_type, quantity, unit_price, reference_number, created_by) VALUES 
-- Main Store inventory
(4, 1, 'IN', 20, 699.99, 'PO-004', 1),  -- iPhone 14 Pro
(5, 1, 'IN', 15, 629.99, 'PO-005', 1),  -- Samsung Galaxy S23
(6, 1, 'IN', 10, 799.99, 'PO-006', 1),  -- MacBook Air M2
(7, 1, 'IN', 12, 749.99, 'PO-007', 1),  -- iPad Pro
(8, 1, 'IN', 30, 149.99, 'PO-008', 1),  -- AirPods Pro

-- Downtown Branch inventory
(4, 2, 'IN', 15, 699.99, 'PO-009', 1),  -- iPhone 14 Pro
(5, 2, 'IN', 10, 629.99, 'PO-010', 1),  -- Samsung Galaxy S23
(9, 2, 'IN', 50, 39.99, 'PO-011', 1),   -- Mens Denim Jeans
(10, 2, 'IN', 30, 29.99, 'PO-012', 1),  -- Womens Summer Dress

-- Uptown Store inventory
(11, 3, 'IN', 8, 179.99, 'PO-013', 1),   -- Leather Jacket
(12, 3, 'IN', 60, 69.99, 'PO-014', 1),   -- Running Shoes
(13, 3, 'IN', 25, 19.99, 'PO-015', 1),   -- Monstera Plant
(14, 3, 'IN', 15, 24.99, 'PO-016', 1),   -- Garden Spade

-- Warehouse inventory
(15, 4, 'IN', 100, 9.99, 'PO-017', 1),   -- Fertilizer
(16, 4, 'IN', 12, 179.99, 'PO-018', 1),  -- Dumbbells
(17, 4, 'IN', 20, 119.99, 'PO-019', 1),  -- Camping Tent
(18, 4, 'IN', 25, 89.99, 'PO-020', 1),   -- Hiking Backpack
(19, 4, 'IN', 40, 24.99, 'PO-021', 1),   -- Java Book
(20, 4, 'IN', 30, 19.99, 'PO-022', 1);   -- Database Book

-- Sample sales orders for different locations and dates
INSERT INTO sales_orders (order_number, customer_name, customer_email, customer_phone, location_id, payment_method, created_by, created_at) VALUES 
('SO-002', 'Michael Smith', 'michael.smith@email.com', '555-1111', 1, 'CASH', 2, '2024-01-15 10:30:00'),
('SO-003', 'Emily Johnson', 'emily.johnson@email.com', '555-2222', 2, 'CARD', 3, '2024-01-15 14:45:00'),
('SO-004', 'Robert Brown', 'robert.brown@email.com', '555-3333', 1, 'CARD', 2, '2024-01-16 09:15:00'),
('SO-005', 'Lisa Davis', 'lisa.davis@email.com', '555-4444', 3, 'CARD', 4, '2024-01-16 16:20:00'),
('SO-006', 'James Wilson', 'james.wilson@email.com', '555-5555', 2, 'CASH', 3, '2024-01-17 11:00:00'),
('SO-007', 'Maria Garcia', 'maria.garcia@email.com', '555-6666', 1, 'ONLINE', 2, '2024-01-17 13:30:00'),
('SO-008', 'David Miller', 'david.miller@email.com', '555-7777', 3, 'CARD', 4, '2024-01-18 10:45:00');

-- Sample sales items
INSERT INTO sales_items (sales_order_id, product_id, quantity, unit_price, total_price) VALUES 
-- Order SO-002 (Michael Smith)
(2, 8, 2, 249.99, 499.98),  -- 2x AirPods Pro
(2, 3, 1, 24.99, 24.99),    -- 1x Cotton T-Shirt

-- Order SO-003 (Emily Johnson)
(3, 4, 1, 999.99, 999.99),  -- 1x iPhone 14 Pro
(3, 8, 1, 249.99, 249.99),  -- 1x AirPods Pro

-- Order SO-004 (Robert Brown)
(4, 2, 1, 89.99, 89.99),    -- 1x Gaming Mouse
(4, 19, 2, 49.99, 99.98),   -- 2x Java Books

-- Order SO-005 (Lisa Davis)
(5, 10, 2, 59.99, 119.98),  -- 2x Summer Dress
(5, 12, 1, 129.99, 129.99), -- 1x Running Shoes

-- Order SO-006 (James Wilson)
(6, 5, 1, 899.99, 899.99),  -- 1x Samsung Galaxy S23
(6, 9, 1, 79.99, 79.99),    -- 1x Mens Jeans

-- Order SO-007 (Maria Garcia)
(7, 6, 1, 1199.99, 1199.99), -- 1x MacBook Air M2

-- Order SO-008 (David Miller)
(8, 13, 3, 39.99, 119.97),   -- 3x Monstera Plants
(8, 15, 2, 19.99, 39.98),    -- 2x Fertilizer
(8, 14, 1, 49.99, 49.99);    -- 1x Garden Spade

-- Add some inventory adjustments
INSERT INTO inventory_transactions (product_id, location_id, transaction_type, quantity, notes, created_by) VALUES 
(1, 1, 'ADJUSTMENT', 2, 'Damaged units removed from inventory', 1),
(3, 1, 'ADJUSTMENT', -5, 'Inventory count correction', 1),
(8, 1, 'ADJUSTMENT', 5, 'Found additional units in storage', 1);

-- Add some transfer transactions
INSERT INTO inventory_transactions (product_id, location_id, transaction_type, quantity, reference_number, notes, created_by) VALUES 
(4, 1, 'OUT', 3, 'TRF-001', 'Transfer to Downtown Branch', 1),
(4, 2, 'IN', 3, 'TRF-001', 'Transfer from Main Store', 1),
(12, 3, 'OUT', 10, 'TRF-002', 'Transfer to Main Store', 1),
(12, 1, 'IN', 10, 'TRF-002', 'Transfer from Uptown Store', 1);
