<%@ page import="java.util.*,java.sql.*,com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) { response.sendRedirect("login.jsp"); return; }

    Map<Integer,Integer> cart = (Map<Integer,Integer>) session.getAttribute("cart");
    if(cart == null || cart.isEmpty()) { response.sendRedirect("cart.jsp"); return; }

    double grandTotal = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - NexusCommerce</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        /* Checkout Page Specific Styles */
        .checkout-header {
            background: var(--bg-gradient);
            padding: var(--space-20) 0;
            text-align: center;
            color: white;
        }
        
        .checkout-header h1 {
            font-size: var(--text-5xl);
            margin-bottom: var(--space-4);
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }
        
        .checkout-header p {
            font-size: var(--text-xl);
            opacity: 0.9;
        }
        
        .checkout-section {
            padding: var(--space-20) 0;
            background: var(--bg-secondary);
            min-height: 60vh;
        }
        
        .checkout-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .checkout-grid {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: var(--space-8);
        }
        
        .order-summary {
            background: var(--bg-primary);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            overflow: hidden;
        }
        
        .order-items {
            padding: var(--space-6);
        }
        
        .order-item {
            display: flex;
            align-items: center;
            padding: var(--space-4);
            border-bottom: 1px solid var(--gray-200);
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: var(--text-xl);
            margin-right: var(--space-4);
            flex-shrink: 0;
        }
        
        .item-details {
            flex: 1;
            min-width: 0;
        }
        
        .item-name {
            font-size: var(--text-base);
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: var(--space-1);
        }
        
        .item-price {
            font-size: var(--text-sm);
            color: var(--gray-600);
        }
        
        .item-quantity {
            font-size: var(--text-sm);
            color: var(--gray-500);
            margin-left: var(--space-4);
        }
        
        .item-total {
            font-size: var(--text-lg);
            font-weight: 700;
            color: var(--primary-color);
            margin-left: var(--space-4);
        }
        
        .order-total {
            background: var(--gray-50);
            padding: var(--space-6);
            border-top: 1px solid var(--gray-200);
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--space-2) 0;
        }
        
        .total-row.final {
            font-size: var(--text-xl);
            font-weight: 700;
            color: var(--gray-900);
            border-top: 2px solid var(--gray-200);
            margin-top: var(--space-4);
            padding-top: var(--space-4);
        }
        
        .checkout-form {
            background: var(--bg-primary);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            padding: var(--space-8);
        }
        
        .form-section {
            margin-bottom: var(--space-8);
        }
        
        .form-section h3 {
            font-size: var(--text-xl);
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: var(--space-4);
            padding-bottom: var(--space-2);
            border-bottom: 2px solid var(--gray-200);
        }
        
        .form-group {
            margin-bottom: var(--space-6);
        }
        
        .form-label {
            display: block;
            font-weight: 500;
            color: var(--gray-700);
            margin-bottom: var(--space-2);
            font-size: var(--text-sm);
        }
        
        .form-input,
        .form-select,
        .form-textarea {
            width: 100%;
            padding: var(--space-4);
            border: 2px solid var(--gray-300);
            border-radius: var(--radius-lg);
            font-size: var(--text-base);
            transition: all var(--transition-fast);
            background: var(--bg-primary);
        }
        
        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .checkout-button {
            width: 100%;
            padding: var(--space-4);
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: var(--text-lg);
            cursor: pointer;
            transition: all var(--transition-fast);
            margin-top: var(--space-6);
        }
        
        .checkout-button:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow-lg);
        }
        
        .checkout-button:active {
            transform: translateY(0);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .checkout-grid {
                grid-template-columns: 1fr;
                gap: var(--space-6);
            }
            
            .checkout-form {
                padding: var(--space-6);
            }
        }
    </style>
</head>
<body>
    <!-- Checkout Header -->
    <section class="checkout-header">
        <div class="container">
            <h1>Checkout</h1>
            <p>Review your order and complete your purchase</p>
        </div>
    </section>

    <!-- Checkout Section -->
    <section class="checkout-section">
        <div class="container">
            <div class="checkout-container">
                <div class="checkout-grid">
                    <!-- Order Summary -->
                    <div class="order-summary">
                        <div class="order-items">
                            <h3 style="margin-bottom: var(--space-6); color: var(--gray-900); font-size: var(--text-xl);">Order Summary</h3>
                            <%
                                Connection conn = null;
                                try {
                                    conn = DBConnection.getConnection();
                                    for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
                                        int pid = entry.getKey();
                                        int qty = entry.getValue();

                                        PreparedStatement ps = null;
                                        ResultSet rs = null;
                                        try {
                                            ps = conn.prepareStatement("SELECT name, price FROM products WHERE id=?");
                                            ps.setInt(1, pid);
                                            rs = ps.executeQuery();
                                            if(rs.next()){
                                                String name = rs.getString("name");
                                                double price = rs.getDouble("price");
                                                double total = price * qty;
                                                grandTotal += total;
                            %>
                            <div class="order-item">
                                <div class="item-image">
                                    <span>🛍️</span>
                                </div>
                                <div class="item-details">
                                    <div class="item-name"><%=name%></div>
                                    <div class="item-price">₹<%=String.format("%.2f", price)%> each</div>
                                </div>
                                <div class="item-quantity">Qty: <%=qty%></div>
                                <div class="item-total">₹<%=String.format("%.2f", total)%></div>
                            </div>
                            <%
                                            }
                                        } finally {
                                            try { if (rs != null) rs.close(); } catch (Exception ex) {}
                                            try { if (ps != null) ps.close(); } catch (Exception ex) {}
                                        }
                                    }
                                } catch(Exception e){ 
                            %>
                            <div class="alert alert-error">
                                Error loading order items: <%=e.getMessage()%>
                            </div>
                            <%
                                } finally {
                                    try { if (conn != null) conn.close(); } catch (Exception ex) {}
                                }
                            %>
                        </div>
                        
                        <div class="order-total">
                            <div class="total-row">
                                <span>Subtotal</span>
                                <span>₹<%=String.format("%.2f", grandTotal)%></span>
                            </div>
                            <div class="total-row">
                                <span>Shipping</span>
                                <span>Free</span>
                            </div>
                            <div class="total-row">
                                <span>Tax</span>
                                <span>₹0.00</span>
                            </div>
                            <div class="total-row final">
                                <span>Total</span>
                                <span>₹<%=String.format("%.2f", grandTotal)%></span>
                            </div>
                        </div>
                    </div>

                    <!-- Checkout Form -->
                    <div class="checkout-form">
                        <form action="placeOrders.jsp" method="post">
                            <div class="form-section">
                                <h3>Shipping Information</h3>
                                <div class="form-group">
                                    <label for="address" class="form-label">Delivery Address</label>
                                    <textarea id="address" name="address" class="form-textarea" 
                                              placeholder="Enter your complete delivery address" required></textarea>
                                </div>
                            </div>

                            <div class="form-section">
                                <h3>Payment Method</h3>
                                <div class="form-group">
                                    <label for="payment" class="form-label">Select Payment Option</label>
                                    <select id="payment" name="payment" class="form-select" required>
                                        <option value="">Choose payment method</option>
                                        <option value="Cash on Delivery">Cash on Delivery</option>
                                        <option value="Online Payment">Online Payment</option>
                                        <option value="Credit Card">Credit Card</option>
                                        <option value="Debit Card">Debit Card</option>
                                    </select>
                                </div>
                            </div>

                            <button type="submit" class="checkout-button">
                                Complete Order - ₹<%=String.format("%.2f", grandTotal)%>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
</body>
</html>