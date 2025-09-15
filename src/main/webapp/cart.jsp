<%@ page import="java.util.*, java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get cart from session
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if(cart == null) cart = new HashMap<Integer, Integer>();

    // Handle remove item from cart
    String removeIdStr = request.getParameter("remove");
    if(removeIdStr != null) {
        int removeId = Integer.parseInt(removeIdStr);
        cart.remove(removeId);
        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - NexusCommerce</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        /* Cart Page Specific Styles */
        .cart-header {
            background: var(--bg-gradient);
            padding: var(--space-20) 0;
            text-align: center;
            color: white;
        }
        
        .cart-header h1 {
            font-size: var(--text-5xl);
            margin-bottom: var(--space-4);
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }
        
        .cart-header p {
            font-size: var(--text-xl);
            opacity: 0.9;
        }
        
        .cart-section {
            padding: var(--space-20) 0;
            background: var(--bg-secondary);
            min-height: 60vh;
        }
        
        .cart-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .cart-items {
            background: var(--bg-primary);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            overflow: hidden;
        }
        
        .cart-item {
            display: flex;
            align-items: center;
            padding: var(--space-6);
            border-bottom: 1px solid var(--gray-200);
            transition: all var(--transition-fast);
        }
        
        .cart-item:hover {
            background: var(--gray-50);
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: var(--text-2xl);
            margin-right: var(--space-6);
            flex-shrink: 0;
        }
        
        .item-details {
            flex: 1;
            min-width: 0;
        }
        
        .item-name {
            font-size: var(--text-lg);
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: var(--space-1);
        }
        
        .item-price {
            font-size: var(--text-xl);
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .item-quantity {
            display: flex;
            align-items: center;
            gap: var(--space-4);
            margin: 0 var(--space-8);
        }
        
        .quantity-display {
            background: var(--gray-100);
            padding: var(--space-2) var(--space-4);
            border-radius: var(--radius-lg);
            font-weight: 600;
            color: var(--gray-700);
            min-width: 60px;
            text-align: center;
        }
        
        .item-total {
            font-size: var(--text-xl);
            font-weight: 700;
            color: var(--gray-900);
            min-width: 100px;
            text-align: right;
        }
        
        .remove-btn {
            background: var(--error-color);
            color: white;
            border: none;
            padding: var(--space-2) var(--space-4);
            border-radius: var(--radius-lg);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-fast);
            margin-left: var(--space-4);
        }
        
        .remove-btn:hover {
            background: #dc2626;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }
        
        .cart-summary {
            background: var(--bg-primary);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            padding: var(--space-8);
            margin-top: var(--space-8);
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--space-3) 0;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .summary-row:last-child {
            border-bottom: none;
            font-size: var(--text-xl);
            font-weight: 700;
            color: var(--gray-900);
            margin-top: var(--space-4);
            padding-top: var(--space-6);
        }
        
        .summary-label {
            color: var(--gray-600);
            font-weight: 500;
        }
        
        .summary-value {
            font-weight: 600;
            color: var(--gray-900);
        }
        
        .summary-total {
            color: var(--primary-color);
            font-size: var(--text-2xl);
        }
        
        .cart-actions {
            display: flex;
            gap: var(--space-4);
            justify-content: center;
            margin-top: var(--space-8);
            flex-wrap: wrap;
        }
        
        .empty-cart {
            text-align: center;
            padding: var(--space-20);
            color: var(--gray-500);
        }
        
        .empty-cart h3 {
            font-size: var(--text-3xl);
            margin-bottom: var(--space-4);
            color: var(--gray-700);
        }
        
        .empty-cart p {
            font-size: var(--text-lg);
            margin-bottom: var(--space-8);
        }
        
        .empty-cart-icon {
            font-size: var(--text-6xl);
            margin-bottom: var(--space-6);
            opacity: 0.5;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .cart-item {
                flex-direction: column;
                align-items: flex-start;
                gap: var(--space-4);
            }
            
            .item-image {
                margin-right: 0;
                margin-bottom: var(--space-4);
            }
            
            .item-quantity {
                margin: 0;
                width: 100%;
                justify-content: space-between;
            }
            
            .item-total {
                text-align: left;
                min-width: auto;
            }
            
            .cart-actions {
                flex-direction: column;
            }
            
            .cart-actions .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="container">
            <div class="navbar-content">
                <a href="index.jsp" class="navbar-brand">NexusCommerce</a>
                <ul class="navbar-nav">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="products.jsp">Products</a></li>
                    <li><a href="cart.jsp" class="active">Cart</a></li>
                    <li><a href="myOrders.jsp">My Orders</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Cart Header -->
    <section class="cart-header">
        <div class="container">
            <h1>Your Shopping Cart</h1>
            <p>Review your items and proceed to checkout</p>
        </div>
    </section>

    <!-- Cart Section -->
    <section class="cart-section">
        <div class="container">
            <div class="cart-container">
                <%
                    double grandTotal = 0.0;
                    int totalItems = 0;

                    if(cart.isEmpty()) {
                %>
                    <div class="empty-cart">
                        <div class="empty-cart-icon">🛒</div>
                        <h3>Your cart is empty</h3>
                        <p>Looks like you haven't added any items to your cart yet.</p>
                        <a href="products.jsp" class="btn btn-primary">Start Shopping</a>
                    </div>
                <%
                    } else {
                %>
                    <div class="cart-items">
                        <%
                            Connection conn = null;
                            try {
                                conn = DBConnection.getConnection();
                                for(Map.Entry<Integer,Integer> entry : cart.entrySet()) {
                                    int pid = entry.getKey();
                                    int qty = entry.getValue();
                                    totalItems += qty;

                                    String sql = "SELECT name, price FROM products WHERE id=?";
                                    PreparedStatement ps = null;
                                    ResultSet rs = null;
                                    try {
                                        ps = conn.prepareStatement(sql);
                                        ps.setInt(1, pid);
                                        rs = ps.executeQuery();
                                        if(rs.next()) {
                                            String name = rs.getString("name");
                                            double price = rs.getDouble("price");
                                            double total = price * qty;
                                            grandTotal += total;
                        %>
                        <div class="cart-item">
                            <div class="item-image">
                                <span>🛍️</span>
                            </div>
                            <div class="item-details">
                                <div class="item-name"><%=name%></div>
                                <div class="item-price">₹<%=String.format("%.2f", price)%></div>
                            </div>
                            <div class="item-quantity">
                                <span class="quantity-display"><%=qty%></span>
                            </div>
                            <div class="item-total">₹<%=String.format("%.2f", total)%></div>
                            <a href="cart.jsp?remove=<%=pid%>" class="remove-btn">Remove</a>
                        </div>
                        <%
                                        }
                                    } finally {
                                        try { if (rs != null) rs.close(); } catch (Exception ex) {}
                                        try { if (ps != null) ps.close(); } catch (Exception ex) {}
                                    }
                                }
                            } catch(Exception e) {
                        %>
                        <div class="alert alert-error">
                            Error loading cart items: <%=e.getMessage()%>
                        </div>
                        <%
                            } finally {
                                try { if (conn != null) conn.close(); } catch (Exception ex) {}
                            }
                        %>
                    </div>

                    <!-- Cart Summary -->
                    <div class="cart-summary">
                        <div class="summary-row">
                            <span class="summary-label">Items (<%=totalItems%>)</span>
                            <span class="summary-value">₹<%=String.format("%.2f", grandTotal)%></span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Shipping</span>
                            <span class="summary-value">Free</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Tax</span>
                            <span class="summary-value">₹0.00</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Total</span>
                            <span class="summary-value summary-total">₹<%=String.format("%.2f", grandTotal)%></span>
                        </div>
                    </div>

                    <!-- Cart Actions -->
                    <div class="cart-actions">
                        <a href="products.jsp" class="btn btn-secondary">Continue Shopping</a>
                        <a href="checkout.jsp" class="btn btn-primary">Proceed to Checkout</a>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </section>
</body>
</html>