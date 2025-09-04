-- Retail Inventory Management System Database Schema
-- MySQL 8.0+ Compatible

-- Create database
CREATE DATABASE IF NOT EXISTS retail_inventory;
USE retail_inventory;

-- Drop existing tables (for clean setup)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS sales_items;
DROP TABLE IF EXISTS sales_orders;
DROP TABLE IF EXISTS inventory_transactions;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- Users table for authentication and authorization
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role ENUM('ADMIN', 'MANAGER', 'STAFF') NOT NULL DEFAULT 'STAFF',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Locations table for multi-store support
CREATE TABLE locations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Categories table for product organization
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id BIGINT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Suppliers table
CREATE TABLE suppliers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    tax_id VARCHAR(50),
    payment_terms VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    category_id BIGINT,
    supplier_id BIGINT,
    barcode VARCHAR(50),
    unit_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    cost_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    weight DECIMAL(8, 3),
    dimensions VARCHAR(50), -- e.g., "10x5x3 cm"
    min_stock_level INT DEFAULT 0,
    max_stock_level INT DEFAULT 1000,
    reorder_point INT DEFAULT 10,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL,
    INDEX idx_sku (sku),
    INDEX idx_barcode (barcode),
    INDEX idx_category (category_id)
);

-- Inventory transactions table for tracking stock movements
CREATE TABLE inventory_transactions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT NOT NULL,
    location_id BIGINT NOT NULL,
    transaction_type ENUM('IN', 'OUT', 'ADJUSTMENT', 'TRANSFER') NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2),
    total_amount DECIMAL(12, 2),
    reference_number VARCHAR(100), -- PO number, sale ID, etc.
    notes TEXT,
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_product_location (product_id, location_id),
    INDEX idx_transaction_type (transaction_type),
    INDEX idx_created_at (created_at)
);

-- Sales orders table
CREATE TABLE sales_orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20),
    location_id BIGINT NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    payment_method ENUM('CASH', 'CARD', 'CHECK', 'ONLINE') NOT NULL,
    payment_status ENUM('PENDING', 'PAID', 'REFUNDED') DEFAULT 'PAID',
    order_status ENUM('PROCESSING', 'COMPLETED', 'CANCELLED') DEFAULT 'COMPLETED',
    notes TEXT,
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_order_number (order_number),
    INDEX idx_created_at (created_at),
    INDEX idx_customer_email (customer_email)
);

-- Sales items table (order line items)
CREATE TABLE sales_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sales_order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (sales_order_id) REFERENCES sales_orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_sales_order (sales_order_id),
    INDEX idx_product (product_id)
);

-- Create view for current inventory levels
CREATE VIEW current_inventory AS
SELECT 
    p.id as product_id,
    p.sku,
    p.name as product_name,
    l.id as location_id,
    l.name as location_name,
    COALESCE(
        SUM(CASE 
            WHEN it.transaction_type IN ('IN', 'ADJUSTMENT') THEN it.quantity 
            WHEN it.transaction_type IN ('OUT', 'TRANSFER') THEN -it.quantity 
            ELSE 0 
        END), 0
    ) as current_stock,
    p.min_stock_level,
    p.reorder_point,
    CASE 
        WHEN COALESCE(
            SUM(CASE 
                WHEN it.transaction_type IN ('IN', 'ADJUSTMENT') THEN it.quantity 
                WHEN it.transaction_type IN ('OUT', 'TRANSFER') THEN -it.quantity 
                ELSE 0 
            END), 0
        ) <= p.reorder_point THEN 'LOW'
        WHEN COALESCE(
            SUM(CASE 
                WHEN it.transaction_type IN ('IN', 'ADJUSTMENT') THEN it.quantity 
                WHEN it.transaction_type IN ('OUT', 'TRANSFER') THEN -it.quantity 
                ELSE 0 
            END), 0
        ) = 0 THEN 'OUT_OF_STOCK'
        ELSE 'NORMAL'
    END as stock_status
FROM products p
CROSS JOIN locations l
LEFT JOIN inventory_transactions it ON p.id = it.product_id AND l.id = it.location_id
WHERE p.is_active = TRUE AND l.is_active = TRUE
GROUP BY p.id, p.sku, p.name, l.id, l.name, p.min_stock_level, p.reorder_point;

-- Insert sample data
-- Default location
INSERT INTO locations (name, address, city, state, zip_code, phone) 
VALUES ('Main Store', '123 Main Street', 'New York', 'NY', '10001', '555-0123');

-- Default admin user (password: admin123)
INSERT INTO users (username, email, password_hash, first_name, last_name, role) 
VALUES ('admin', 'admin@retailstore.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE7GCJ4NGMcV7SkE6', 'System', 'Administrator', 'ADMIN');

-- Sample categories
INSERT INTO categories (name, description) VALUES 
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and fashion items'),
('Home & Garden', 'Home improvement and gardening supplies'),
('Sports & Outdoors', 'Sports equipment and outdoor gear'),
('Books', 'Books and educational materials');

-- Sample supplier
INSERT INTO suppliers (name, contact_person, email, phone, address, city, state, zip_code) 
VALUES ('Tech Solutions Inc.', 'John Smith', 'john@techsolutions.com', '555-0456', '456 Tech Ave', 'San Francisco', 'CA', '94102');

-- Sample products
INSERT INTO products (sku, name, description, category_id, supplier_id, barcode, unit_price, cost_price, min_stock_level, reorder_point) 
VALUES 
('LAPTOP001', 'Gaming Laptop Pro', 'High-performance gaming laptop with RTX graphics', 1, 1, '123456789012', 1299.99, 899.99, 5, 10),
('MOUSE001', 'Wireless Gaming Mouse', 'Precision wireless gaming mouse', 1, 1, '123456789013', 89.99, 45.99, 20, 30),
('SHIRT001', 'Cotton T-Shirt', 'Comfortable cotton t-shirt available in multiple colors', 2, NULL, '123456789014', 24.99, 12.99, 50, 75);

-- Sample inventory transactions
INSERT INTO inventory_transactions (product_id, location_id, transaction_type, quantity, unit_price, reference_number, created_by) 
VALUES 
(1, 1, 'IN', 15, 899.99, 'PO-001', 1),
(2, 1, 'IN', 50, 45.99, 'PO-002', 1),
(3, 1, 'IN', 100, 12.99, 'PO-003', 1);

-- Sample sales order
INSERT INTO sales_orders (order_number, customer_name, customer_email, location_id, subtotal, tax_amount, total_amount, payment_method, created_by) 
VALUES ('SO-001', 'Jane Doe', 'jane.doe@email.com', 1, 1389.98, 111.20, 1501.18, 'CARD', 1);

-- Sample sales items
INSERT INTO sales_items (sales_order_id, product_id, quantity, unit_price, total_price) 
VALUES 
(1, 1, 1, 1299.99, 1299.99),
(1, 2, 1, 89.99, 89.99);

-- Update inventory for the sale
INSERT INTO inventory_transactions (product_id, location_id, transaction_type, quantity, reference_number, created_by) 
VALUES 
(1, 1, 'OUT', 1, 'SO-001', 1),
(2, 1, 'OUT', 1, 'SO-001', 1);

-- Create stored procedures for common operations

DELIMITER //

-- Procedure to get current stock for a product at a location
CREATE PROCEDURE GetProductStock(
    IN p_product_id BIGINT,
    IN p_location_id BIGINT,
    OUT p_current_stock INT
)
BEGIN
    SELECT COALESCE(
        SUM(CASE 
            WHEN transaction_type IN ('IN', 'ADJUSTMENT') THEN quantity 
            WHEN transaction_type IN ('OUT', 'TRANSFER') THEN -quantity 
            ELSE 0 
        END), 0
    ) INTO p_current_stock
    FROM inventory_transactions 
    WHERE product_id = p_product_id AND location_id = p_location_id;
END //

-- Procedure to process a sale and update inventory
CREATE PROCEDURE ProcessSale(
    IN p_order_number VARCHAR(50),
    IN p_customer_name VARCHAR(100),
    IN p_customer_email VARCHAR(100),
    IN p_location_id BIGINT,
    IN p_payment_method VARCHAR(20),
    IN p_created_by BIGINT,
    OUT p_order_id BIGINT
)
BEGIN
    INSERT INTO sales_orders (
        order_number, customer_name, customer_email, location_id, 
        payment_method, created_by
    ) VALUES (
        p_order_number, p_customer_name, p_customer_email, p_location_id,
        p_payment_method, p_created_by
    );
    
    SET p_order_id = LAST_INSERT_ID();
END //

DELIMITER ;

-- Create indexes for better performance
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_inventory_date ON inventory_transactions(created_at);
CREATE INDEX idx_sales_date ON sales_orders(created_at);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);

-- Create triggers for automatic calculations

DELIMITER //

-- Trigger to update sales order totals when sales items are inserted/updated
CREATE TRIGGER update_sales_order_totals 
AFTER INSERT ON sales_items
FOR EACH ROW
BEGIN
    UPDATE sales_orders 
    SET subtotal = (
        SELECT SUM(total_price) 
        FROM sales_items 
        WHERE sales_order_id = NEW.sales_order_id
    ),
    tax_amount = subtotal * 0.08, -- 8% tax rate
    total_amount = subtotal + tax_amount
    WHERE id = NEW.sales_order_id;
END //

-- Trigger to create inventory transaction when sale is made
CREATE TRIGGER create_inventory_transaction_on_sale
AFTER INSERT ON sales_items
FOR EACH ROW
BEGIN
    DECLARE order_number VARCHAR(50);
    DECLARE location_id BIGINT;
    
    SELECT so.order_number, so.location_id 
    INTO order_number, location_id
    FROM sales_orders so 
    WHERE so.id = NEW.sales_order_id;
    
    INSERT INTO inventory_transactions (
        product_id, location_id, transaction_type, quantity, 
        unit_price, reference_number, created_by
    ) VALUES (
        NEW.product_id, location_id, 'OUT', NEW.quantity,
        NEW.unit_price, order_number, 
        (SELECT created_by FROM sales_orders WHERE id = NEW.sales_order_id)
    );
END //

DELIMITER ;

-- Create user for application (replace with your credentials)
-- CREATE USER 'inventory_user'@'localhost' IDENTIFIED BY 'secure_password_123';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON retail_inventory.* TO 'inventory_user'@'localhost';
-- FLUSH PRIVILEGES;
