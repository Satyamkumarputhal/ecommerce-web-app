<%@ page import="java.sql.*, java.util.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - NexusCommerce</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        /* Products Page Specific Styles */
        .products-header {
            background: var(--bg-gradient);
            padding: var(--space-20) 0;
            text-align: center;
            color: white;
        }
        
        .products-header h1 {
            font-size: var(--text-5xl);
            margin-bottom: var(--space-4);
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }
        
        .products-header p {
            font-size: var(--text-xl);
            opacity: 0.9;
        }
        
        .products-section {
            padding: var(--space-20) 0;
            background: var(--bg-secondary);
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: var(--space-8);
            margin-top: var(--space-12);
        }
        
        .product-card {
            background: var(--bg-primary);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            overflow: hidden;
            transition: all var(--transition-normal);
            position: relative;
        }
        
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-xl);
            border-color: var(--primary-color);
        }
        
        .product-image {
            height: 200px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: var(--text-4xl);
            position: relative;
            overflow: hidden;
        }
        
        .product-image::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="%23ffffff" stroke-width="0.5" opacity="0.3"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            opacity: 0.3;
        }
        
        .product-badge {
            position: absolute;
            top: var(--space-3);
            right: var(--space-3);
            background: var(--success-color);
            color: white;
            padding: var(--space-1) var(--space-3);
            border-radius: var(--radius-full);
            font-size: var(--text-xs);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .product-content {
            padding: var(--space-6);
        }
        
        .product-title {
            font-size: var(--text-xl);
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: var(--space-2);
            line-height: 1.3;
        }
        
        .product-description {
            color: var(--gray-600);
            font-size: var(--text-sm);
            line-height: 1.5;
            margin-bottom: var(--space-4);
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .product-price {
            font-size: var(--text-2xl);
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: var(--space-4);
        }
        
        .product-stock {
            display: flex;
            align-items: center;
            gap: var(--space-2);
            margin-bottom: var(--space-4);
            font-size: var(--text-sm);
        }
        
        .stock-indicator {
            width: 8px;
            height: 8px;
            border-radius: var(--radius-full);
            background: var(--success-color);
        }
        
        .stock-indicator.low {
            background: var(--warning-color);
        }
        
        .stock-indicator.out {
            background: var(--error-color);
        }
        
        .product-form {
            display: flex;
            gap: var(--space-3);
            align-items: center;
        }
        
        .quantity-input {
            width: 80px;
            padding: var(--space-2);
            border: 2px solid var(--gray-300);
            border-radius: var(--radius-lg);
            text-align: center;
            font-weight: 500;
        }
        
        .quantity-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        .add-to-cart-btn {
            flex: 1;
            background: var(--primary-color);
            color: white;
            border: none;
            padding: var(--space-3) var(--space-4);
            border-radius: var(--radius-lg);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-fast);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: var(--space-2);
        }
        
        .add-to-cart-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }
        
        .add-to-cart-btn:disabled {
            background: var(--gray-400);
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .empty-state {
            text-align: center;
            padding: var(--space-20);
            color: var(--gray-500);
        }
        
        .empty-state h3 {
            font-size: var(--text-2xl);
            margin-bottom: var(--space-4);
            color: var(--gray-700);
        }
        
        .empty-state p {
            font-size: var(--text-lg);
            margin-bottom: var(--space-8);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: var(--space-6);
            }
            
            .product-form {
                flex-direction: column;
                gap: var(--space-4);
            }
            
            .quantity-input {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <%
        // Check for cart messages
        String cartMessage = (String) session.getAttribute("cartMessage");
        String cartMessageType = (String) session.getAttribute("cartMessageType");
        
        // Clear the message after displaying
        if(cartMessage != null) {
            session.removeAttribute("cartMessage");
            session.removeAttribute("cartMessageType");
        }
        
        // Get cart size for counter
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        int cartSize = 0;
        if(cart != null && !cart.isEmpty()) {
            for(Integer qty : cart.values()) {
                cartSize += qty;
            }
        }
    %>
    
    <!-- Navigation -->
    <nav class="navbar">
        <div class="container">
            <div class="navbar-content">
                <a href="index.jsp" class="navbar-brand">NexusCommerce</a>
                <ul class="navbar-nav">
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="products.jsp" class="active">Products</a></li>
                    <li><a href="cart.jsp" class="cart-link" style="position: relative;">Cart
                        <% if(cartSize > 0) { %>
                            <span class="cart-counter"><%=cartSize%></span>
                        <% } %>
                    </a></li>
                    <li><a href="myOrders.jsp">My Orders</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Products Header -->
    <section class="products-header">
        <div class="container">
            <h1>Our Products</h1>
            <p>Discover our curated collection of premium products</p>
        </div>
    </section>

    <!-- Products Section -->
    <section class="products-section">
        <div class="container">
            <% if(cartMessage != null) { %>
                <div class="alert alert-<%=cartMessageType.equals("success") ? "success" : "error"%>">
                    <%=cartMessage%>
                </div>
            <% } %>

            <%
                Connection conn = null;
                Statement st = null;
                ResultSet rs = null;
                boolean hasProducts = false;
                try {
                    conn = DBConnection.getConnection();
                    st = conn.createStatement();
                    rs = st.executeQuery("SELECT * FROM products");
            %>
                    <div class="products-grid">
            <%
                    while(rs.next()){
                        hasProducts = true;
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        String desc = rs.getString("description");
                        double price = rs.getDouble("price");
                        int stock = rs.getInt("stock");
                        
                        // Determine stock status
                        String stockClass = "stock-indicator";
                        String stockText = stock + " in stock";
                        if(stock == 0) {
                            stockClass += " out";
                            stockText = "Out of stock";
                        } else if(stock < 10) {
                            stockClass += " low";
                            stockText = "Only " + stock + " left";
                        }
            %>
                        <div class="product-card">
                            <div class="product-image">
                                <div class="product-badge">New</div>
                                <span>🛍️</span>
                            </div>
                            <div class="product-content">
                                <h3 class="product-title"><%=name%></h3>
                                <p class="product-description"><%=desc%></p>
                                <div class="product-price">₹<%=String.format("%.2f", price)%></div>
                                <div class="product-stock">
                                    <div class="<%=stockClass%>"></div>
                                    <span><%=stockText%></span>
                                </div>
                                <form action="addToCart.jsp" method="get" class="product-form">
                                    <input type="hidden" name="productId" value="<%=id%>">
                                    <input type="number" name="quantity" value="1" min="1" max="<%=stock%>" 
                                           class="quantity-input" required <%=stock == 0 ? "disabled" : ""%>>
                                    <button type="submit" class="add-to-cart-btn" <%=stock == 0 ? "disabled" : ""%>>
                                        <span>🛒</span>
                                        <%=stock == 0 ? "Out of Stock" : "Add to Cart"%>
                                    </button>
                                </form>
                            </div>
                        </div>
            <%
                    }
            %>
                    </div>
            <%
                    if(!hasProducts) {
            %>
                        <div class="empty-state">
                            <h3>No Products Available</h3>
                            <p>We're currently updating our inventory. Please check back later!</p>
                            <a href="index.jsp" class="btn btn-primary">Return Home</a>
                        </div>
            <%
                    }
                } catch(Exception e){
            %>
                    <div class="alert alert-error">
                        Error loading products: <%=e.getMessage()%>
                    </div>
            <%
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception ex) {}
                    try { if (st != null) st.close(); } catch (Exception ex) {}
                    try { if (conn != null) conn.close(); } catch (Exception ex) {}
                }
            %>
        </div>
    </section>
</body>
</html>