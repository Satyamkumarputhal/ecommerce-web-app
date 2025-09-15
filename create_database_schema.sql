-- =========================================
-- E-COMMERCE DATABASE SCHEMA CREATION
-- =========================================

-- Create database
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- =========================================
-- 1. USERS TABLE
-- =========================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    dob DATE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address TEXT,
    role ENUM('User', 'Admin', 'Guest') DEFAULT 'User',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- 2. PRODUCTS TABLE
-- =========================================
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    category VARCHAR(50),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- 3. ORDERS TABLE
-- =========================================
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    payment_method ENUM('Cash on Delivery', 'Online Payment') NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_email) REFERENCES users(email) ON DELETE CASCADE
);

-- =========================================
-- 4. ORDER_ITEMS TABLE
-- =========================================
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- =========================================
-- 5. SAMPLE DATA INSERTION
-- =========================================

-- Insert sample users
INSERT INTO users (fullname, email, password, gender, dob, phone, address, role) VALUES
('Admin User', 'admin@ecommerce.com', 'admin123', 'Male', '1990-01-01', '9999999999', 'Admin Office, Tech City', 'Admin'),
('John Doe', 'john@email.com', 'john123', 'Male', '1995-05-15', '9876543210', '123 Main St, Cityville', 'User'),
('Jane Smith', 'jane@email.com', 'jane123', 'Female', '1998-08-20', '8765432109', '456 Oak Ave, Townsburg', 'User');

-- Insert sample products
INSERT INTO products (name, description, price, stock, category) VALUES
('Laptop', 'High-performance laptop for work and gaming', 75000.00, 50, 'Electronics'),
('Smartphone', 'Latest Android smartphone with great camera', 25000.00, 100, 'Electronics'),
('Headphones', 'Wireless Bluetooth headphones with noise cancellation', 5000.00, 75, 'Electronics'),
('T-Shirt', 'Cotton comfortable t-shirt for casual wear', 800.00, 200, 'Clothing'),
('Jeans', 'Premium denim jeans for men and women', 2500.00, 150, 'Clothing'),
('Running Shoes', 'Comfortable running shoes for sports', 4000.00, 80, 'Footwear'),
('Coffee Mug', 'Ceramic coffee mug for daily use', 300.00, 300, 'Home & Kitchen'),
('Book - Programming', 'Complete guide to web development', 1200.00, 50, 'Books'),
('Backpack', 'Durable backpack for travel and daily use', 1800.00, 60, 'Accessories'),
('Water Bottle', 'Stainless steel water bottle', 600.00, 120, 'Accessories');

-- =========================================
-- 6. CREATE INDEXES FOR PERFORMANCE
-- =========================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_user_email ON orders(user_email);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- =========================================
-- 7. SHOW TABLES AND SAMPLE DATA
-- =========================================
SHOW TABLES;

SELECT 'USERS TABLE' as Info;
SELECT * FROM users;

SELECT 'PRODUCTS TABLE' as Info;
SELECT * FROM products;

SELECT 'Database schema created successfully!' as Status;