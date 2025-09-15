package com.ecommerce;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/ecommerce_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "Satyam@8269";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load driver (optional for MySQL 8+)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Get connection
            conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ Database connected successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL JDBC Driver not found. Please add mysql-connector-j.jar to classpath.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ Connection failed. Check DB URL, username, or password.");
            e.printStackTrace();
        }
        return conn;
    }
}
