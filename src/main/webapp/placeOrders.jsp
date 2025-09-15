<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null){
        response.sendRedirect("login.jsp");
        return;
    }

    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if(cart == null || cart.isEmpty()){
        response.sendRedirect("cart.jsp");
        return;
    }

    String address = request.getParameter("address");
    String payment = request.getParameter("payment");

    int orderId = 0;
    double grandTotal = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - NexusCommerce</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        /* Order Confirmation Page Specific Styles */
        .confirmation-container {
            min-height: 100vh;
            background: var(--bg-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: var(--space-4);
            position: relative;
            overflow: hidden;
        }
        
        .confirmation-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><defs><radialGradient id="a" cx="50%" cy="50%"><stop offset="0%" stop-color="%23ffffff" stop-opacity="0.1"/><stop offset="100%" stop-color="%23ffffff" stop-opacity="0"/></radialGradient></defs><circle cx="200" cy="200" r="100" fill="url(%23a)"/><circle cx="800" cy="300" r="150" fill="url(%23a)"/><circle cx="400" cy="700" r="120" fill="url(%23a)"/></svg>') no-repeat center center;
            background-size: cover;
            opacity: 0.3;
        }
        
        .confirmation-card {
            background: var(--bg-primary);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-2xl);
            padding: var(--space-12);
            width: 100%;
            max-width: 800px;
            position: relative;
            z-index: 2;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: fadeIn 0.8s ease-out;
            text-align: center;
        }
        
        .success-icon {
            width: 100px;
            height: 100px;
            background: var(--success-color);
            border-radius: var(--radius-full);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto var(--space-6);
            font-size: var(--text-5xl);
            color: white;
            animation: pulse 2s infinite;
        }
        
        .confirmation-title {
            font-size: var(--text-4xl);
            font-weight: 700;
            color: var(--success-color);
            margin-bottom: var(--space-4);
        }
        
        .confirmation-subtitle {
            font-size: var(--text-xl);
            color: var(--gray-600);
            margin-bottom: var(--space-8);
        }
        
        .order-details {
            background: var(--gray-50);
            border-radius: var(--radius-xl);
            padding: var(--space-6);
            margin: var(--space-8) 0;
            text-align: left;
        }
        
        .order-id {
            font-size: var(--text-2xl);
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: var(--space-4);
            text-align: center;
        }
        
        .order-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: var(--space-4);
        }
        
        .order-table th {
            background: var(--primary-color);
            color: white;
            padding: var(--space-3);
            text-align: center;
            font-weight: 600;
        }
        
        .order-table td {
            padding: var(--space-3);
            text-align: center;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .order-table tr:last-child td {
            border-bottom: none;
        }
        
        .order-total {
            background: var(--primary-color);
            color: white;
            font-weight: 700;
            font-size: var(--text-lg);
        }
        
        .confirmation-actions {
            display: flex;
            gap: var(--space-4);
            justify-content: center;
            margin-top: var(--space-8);
            flex-wrap: wrap;
        }
        
        .confirmation-btn {
            padding: var(--space-4) var(--space-8);
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: var(--text-base);
            text-decoration: none;
            transition: all var(--transition-fast);
            display: inline-flex;
            align-items: center;
            gap: var(--space-2);
        }
        
        .confirmation-btn-primary {
            background: var(--primary-color);
            color: white;
        }
        
        .confirmation-btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }
        
        .confirmation-btn-secondary {
            background: var(--gray-100);
            color: var(--gray-700);
            border: 2px solid var(--gray-300);
        }
        
        .confirmation-btn-secondary:hover {
            background: var(--gray-200);
            border-color: var(--gray-400);
            transform: translateY(-2px);
        }
        
        .confirmation-message {
            background: #ecfdf5;
            color: #065f46;
            border: 1px solid #a7f3d0;
            padding: var(--space-4);
            border-radius: var(--radius-lg);
            margin: var(--space-6) 0;
            font-weight: 500;
        }
        
        .error-message {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
            padding: var(--space-4);
            border-radius: var(--radius-lg);
            margin: var(--space-6) 0;
            font-weight: 500;
        }
        
        /* Animations */
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .confirmation-card {
                padding: var(--space-8);
                margin: var(--space-4);
            }
            
            .confirmation-title {
                font-size: var(--text-3xl);
            }
            
            .confirmation-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .confirmation-btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <div class="confirmation-card">
            <%
                Connection conn = null;
                try {
                    conn = DBConnection.getConnection();
                    conn.setAutoCommit(false);

                    // Calculate grand total
                    for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
                        int pid = entry.getKey();
                        int qty = entry.getValue();
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            ps = conn.prepareStatement("SELECT price FROM products WHERE id=?");
                            ps.setInt(1, pid);
                            rs = ps.executeQuery();
                            if(rs.next()) grandTotal += rs.getDouble("price") * qty;
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception ex) {}
                            try { if (ps != null) ps.close(); } catch (Exception ex) {}
                        }
                    }

                    // Insert order
                    PreparedStatement psOrder = null;
                    ResultSet rsOrder = null;
                    try {
                        psOrder = conn.prepareStatement(
                            "INSERT INTO orders(user_email,address,payment_method,total) VALUES(?,?,?,?)",
                            Statement.RETURN_GENERATED_KEYS
                        );
                        psOrder.setString(1, userEmail);
                        psOrder.setString(2, address);
                        psOrder.setString(3, payment);
                        psOrder.setDouble(4, grandTotal);
                        psOrder.executeUpdate();

                        rsOrder = psOrder.getGeneratedKeys();
                        if(rsOrder.next()) orderId = rsOrder.getInt(1);
                    } finally {
                        try { if (rsOrder != null) rsOrder.close(); } catch (Exception ex) {}
                        try { if (psOrder != null) psOrder.close(); } catch (Exception ex) {}
                    }

                    // Insert order_items
                    for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
                        int pid = entry.getKey();
                        int qty = entry.getValue();
                        double price = 0;
                        PreparedStatement psPrice = null;
                        ResultSet rsPrice = null;
                        try {
                            psPrice = conn.prepareStatement("SELECT price FROM products WHERE id=?");
                            psPrice.setInt(1, pid);
                            rsPrice = psPrice.executeQuery();
                            if(rsPrice.next()) price = rsPrice.getDouble("price");
                        } finally {
                            try { if (rsPrice != null) rsPrice.close(); } catch (Exception ex) {}
                            try { if (psPrice != null) psPrice.close(); } catch (Exception ex) {}
                        }

                        PreparedStatement psItem = null;
                        try {
                            psItem = conn.prepareStatement(
                                "INSERT INTO order_items(order_id,product_id,quantity,price) VALUES(?,?,?,?)"
                            );
                            psItem.setInt(1, orderId);
                            psItem.setInt(2, pid);
                            psItem.setInt(3, qty);
                            psItem.setDouble(4, price);
                            psItem.executeUpdate();
                        } finally {
                            try { if (psItem != null) psItem.close(); } catch (Exception ex) {}
                        }
                    }

                    conn.commit();
                    session.removeAttribute("cart");
            %>

            <div class="success-icon">✓</div>
            <h1 class="confirmation-title">Order Placed Successfully!</h1>
            <p class="confirmation-subtitle">Thank you for your purchase. Your order has been confirmed.</p>

            <div class="order-details">
                <div class="order-id">Order ID: #<%=orderId%></div>
                
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>Product ID</th>
                            <th>Quantity</th>
                            <th>Price (₹)</th>
                            <th>Total (₹)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
                                int pid = entry.getKey();
                                int qty = entry.getValue();
                                double price = 0;
                                PreparedStatement psPrice = null;
                                ResultSet rsPrice = null;
                                try {
                                    psPrice = conn.prepareStatement("SELECT price FROM products WHERE id=?");
                                    psPrice.setInt(1, pid);
                                    rsPrice = psPrice.executeQuery();
                                    if(rsPrice.next()) price = rsPrice.getDouble("price");
                                } finally {
                                    try { if (rsPrice != null) rsPrice.close(); } catch (Exception ex) {}
                                    try { if (psPrice != null) psPrice.close(); } catch (Exception ex) {}
                                }
                                double total = price * qty;
                        %>
                        <tr>
                            <td><%=pid%></td>
                            <td><%=qty%></td>
                            <td>₹<%=String.format("%.2f", price)%></td>
                            <td>₹<%=String.format("%.2f", total)%></td>
                        </tr>
                        <% } %>
                        <tr class="order-total">
                            <td colspan="3"><strong>Grand Total</strong></td>
                            <td><strong>₹<%=String.format("%.2f", grandTotal)%></strong></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="confirmation-message">
                <strong>What's next?</strong><br>
                You will receive an email confirmation shortly. We'll notify you when your order ships.
            </div>

            <div class="confirmation-actions">
                <a href="products.jsp" class="confirmation-btn confirmation-btn-primary">
                    <span>🛍️</span>
                    Continue Shopping
                </a>
                <a href="myOrders.jsp" class="confirmation-btn confirmation-btn-secondary">
                    <span>📋</span>
                    View My Orders
                </a>
            </div>

            <%
                } catch(Exception e){
            %>
            <div class="error-message">
                <strong>Error placing order:</strong> <%=e.getMessage()%>
            </div>
            <%
                    e.printStackTrace();
                } finally {
                    try { if (conn != null) conn.close(); } catch (Exception ex) {}
                }
            %>
        </div>
    </div>
</body>
</html>