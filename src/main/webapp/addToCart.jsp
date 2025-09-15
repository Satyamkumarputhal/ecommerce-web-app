<%@ page import="java.util.*, java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    
    // Get cart from session
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if(cart == null) cart = new HashMap<Integer, Integer>();

    String message = "";
    String messageType = "success";
    
    // Process add to cart request
    String prodIdStr = request.getParameter("productId");
    String qtyStr = request.getParameter("quantity");
    
    if(prodIdStr != null && qtyStr != null) {
        try {
            int prodId = Integer.parseInt(prodIdStr);
            int qty = Integer.parseInt(qtyStr);
            
            // Get product name for confirmation message
            String productName = "";
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            try {
                conn = DBConnection.getConnection();
                ps = conn.prepareStatement("SELECT name FROM products WHERE id=?");
                ps.setInt(1, prodId);
                rs = ps.executeQuery();
                if(rs.next()) {
                    productName = rs.getString("name");
                }
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ex) {}
                try { if (ps != null) ps.close(); } catch (Exception ex) {}
                try { if (conn != null) conn.close(); } catch (Exception ex) {}
            }
            
            // Add to cart
            cart.put(prodId, cart.getOrDefault(prodId, 0) + qty);
            session.setAttribute("cart", cart);
            
            message = "✅ " + qty + " x " + productName + " added to cart successfully!";
            
        } catch (Exception e) {
            message = "❌ Error adding item to cart: " + e.getMessage();
            messageType = "error";
        }
    }
    
    // Store message in session and redirect back to products
    session.setAttribute("cartMessage", message);
    session.setAttribute("cartMessageType", messageType);
    response.sendRedirect("products.jsp");
%>