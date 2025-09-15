<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - NexusCommerce</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        /* Orders Page Specific Styles */
        .orders-header {
            background: var(--bg-gradient);
            padding: var(--space-20) 0;
            text-align: center;
            color: white;
        }
        
        .orders-header h1 {
            font-size: var(--text-5xl);
            margin-bottom: var(--space-4);
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }
        
        .orders-header p {
            font-size: var(--text-xl);
            opacity: 0.9;
        }
        
        .orders-section {
            padding: var(--space-20) 0;
            background: var(--bg-secondary);
            min-height: 60vh;
        }
        
        .orders-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .order-card {
            background: var(--bg-primary);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            margin-bottom: var(--space-8);
            overflow: hidden;
            transition: all var(--transition-normal);
        }
        
        .order-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-xl);
            border-color: var(--primary-color);
        }
        
        .order-header {
            background: var(--gray-50);
            padding: var(--space-6);
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: var(--space-4);
        }
        
        .order-id {
            font-size: var(--text-xl);
            font-weight: 700;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }
        
        .order-date {
            color: var(--gray-600);
            font-size: var(--text-sm);
        }
        
        .order-status {
            background: var(--success-color);
            color: white;
            padding: var(--space-2) var(--space-4);
            border-radius: var(--radius-full);
            font-size: var(--text-xs);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .order-details {
            padding: var(--space-6);
        }
        
        .order-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--space-4);
            margin-bottom: var(--space-6);
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
            gap: var(--space-1);
        }
        
        .info-label {
            font-size: var(--text-xs);
            font-weight: 600;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .info-value {
            font-size: var(--text-sm);
            color: var(--gray-700);
            font-weight: 500;
        }
        
        .order-total {
            font-size: var(--text-lg);
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .order-items {
            margin-top: var(--space-6);
        }
        
        .items-table {
            width: 100%;
            border-collapse: collapse;
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }
        
        .items-table th {
            background: var(--primary-color);
            color: white;
            padding: var(--space-3);
            text-align: left;
            font-weight: 600;
            font-size: var(--text-sm);
        }
        
        .items-table td {
            padding: var(--space-3);
            border-bottom: 1px solid var(--gray-200);
            font-size: var(--text-sm);
        }
        
        .items-table tr:last-child td {
            border-bottom: none;
        }
        
        .items-table tr:nth-child(even) {
            background: var(--gray-50);
        }
        
        .empty-orders {
            text-align: center;
            padding: var(--space-20);
            color: var(--gray-500);
        }
        
        .empty-orders h3 {
            font-size: var(--text-3xl);
            margin-bottom: var(--space-4);
            color: var(--gray-700);
        }
        
        .empty-orders p {
            font-size: var(--text-lg);
            margin-bottom: var(--space-8);
        }
        
        .empty-orders-icon {
            font-size: var(--text-6xl);
            margin-bottom: var(--space-6);
            opacity: 0.5;
        }
        
        .login-prompt {
            text-align: center;
            padding: var(--space-20);
            color: var(--gray-500);
        }
        
        .login-prompt h3 {
            font-size: var(--text-2xl);
            margin-bottom: var(--space-4);
            color: var(--gray-700);
        }
        
        .login-prompt p {
            font-size: var(--text-lg);
            margin-bottom: var(--space-8);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .order-info {
                grid-template-columns: 1fr;
            }
            
            .items-table {
                font-size: var(--text-xs);
            }
            
            .items-table th,
            .items-table td {
                padding: var(--space-2);
            }
        }
    </style>
</head>
<body>
    <!-- Orders Header -->
    <section class="orders-header">
        <div class="container">
            <h1>My Orders</h1>
            <p>Track and manage your order history</p>
        </div>
    </section>

    <!-- Orders Section -->
    <section class="orders-section">
        <div class="container">
            <div class="orders-container">
                <%
                    String email = (String) session.getAttribute("userEmail");
                    if (email == null) {
                %>
                    <div class="login-prompt">
                        <div class="empty-orders-icon">🔒</div>
                        <h3>Please Login</h3>
                        <p>You need to be logged in to view your orders.</p>
                        <a href="login.jsp" class="btn btn-primary">Login Now</a>
                    </div>
                <%
                    } else {
                        Connection conn = null;
                        try {
                            conn = DBConnection.getConnection();
                            String sql = "SELECT * FROM orders WHERE user_email=? ORDER BY order_date DESC";
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            try {
                                ps = conn.prepareStatement(sql);
                                ps.setString(1, email);
                                rs = ps.executeQuery();
                                boolean hasOrders = false;
                                while (rs.next()) {
                                    hasOrders = true;
                                    int orderId = rs.getInt("id");
                                    String addr = rs.getString("address");
                                    String payment = rs.getString("payment_method");
                                    double total = rs.getDouble("total");
                                    Timestamp date = rs.getTimestamp("order_date");
                %>
                    <div class="order-card">
                        <div class="order-header">
                            <div>
                                <div class="order-id">
                                    <span>📦</span>
                                    Order #<%= orderId %>
                                </div>
                                <div class="order-date">Placed on <%= date %></div>
                            </div>
                            <div class="order-status">Completed</div>
                        </div>
                        
                        <div class="order-details">
                            <div class="order-info">
                                <div class="info-item">
                                    <div class="info-label">Delivery Address</div>
                                    <div class="info-value"><%= addr %></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Payment Method</div>
                                    <div class="info-value"><%= payment %></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Total Amount</div>
                                    <div class="info-value order-total">₹<%=String.format("%.2f", total)%></div>
                                </div>
                            </div>
                            
                            <div class="order-items">
                                <table class="items-table">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price (₹)</th>
                                            <th>Quantity</th>
                                            <th>Subtotal (₹)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            String itemSql = "SELECT oi.*, p.name FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id=?";
                                            PreparedStatement ps2 = null;
                                            ResultSet rs2 = null;
                                            try {
                                                ps2 = conn.prepareStatement(itemSql);
                                                ps2.setInt(1, orderId);
                                                rs2 = ps2.executeQuery();
                                                while (rs2.next()) {
                                                    String pname = rs2.getString("name");
                                                    double price = rs2.getDouble("price");
                                                    int qty = rs2.getInt("quantity");
                                                    double subtotal = price * qty;
                                        %>
                                        <tr>
                                            <td><%= pname %></td>
                                            <td>₹<%=String.format("%.2f", price)%></td>
                                            <td><%= qty %></td>
                                            <td>₹<%=String.format("%.2f", subtotal)%></td>
                                        </tr>
                                        <%
                                                }
                                            } finally {
                                                try { if (rs2 != null) rs2.close(); } catch (Exception ex) {}
                                                try { if (ps2 != null) ps2.close(); } catch (Exception ex) {}
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                <%
                                }
                                if (!hasOrders) {
                %>
                    <div class="empty-orders">
                        <div class="empty-orders-icon">📦</div>
                        <h3>No Orders Yet</h3>
                        <p>You haven't placed any orders yet. Start shopping to see your orders here!</p>
                        <a href="products.jsp" class="btn btn-primary">Start Shopping</a>
                    </div>
                <%
                                }
                            } finally {
                                try { if (rs != null) rs.close(); } catch (Exception ex) {}
                                try { if (ps != null) ps.close(); } catch (Exception ex) {}
                            }
                        } catch (Exception e) {
                %>
                    <div class="alert alert-error">
                        Error loading orders: <%=e.getMessage()%>
                    </div>
                <%
                        } finally {
                            try { if (conn != null) conn.close(); } catch (Exception ex) {}
                        }
                    }
                %>
            </div>
        </div>
    </section>
</body>
</html>