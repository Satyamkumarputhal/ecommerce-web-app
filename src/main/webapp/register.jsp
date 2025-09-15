<%@ page import="java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - NexusCommerce</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        /* Registration Page Specific Styles */
        .auth-container {
            min-height: 100vh;
            background: var(--bg-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: var(--space-4);
            position: relative;
            overflow: hidden;
        }
        
        .auth-container::before {
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
        
        .auth-card {
            background: var(--bg-primary);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-2xl);
            padding: var(--space-12);
            width: 100%;
            max-width: 500px;
            position: relative;
            z-index: 2;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: fadeIn 0.8s ease-out;
            max-height: 90vh;
            overflow-y: auto;
        }
        
        .auth-header {
            text-align: center;
            margin-bottom: var(--space-8);
        }
        
        .auth-logo {
            font-family: var(--font-display);
            font-size: var(--text-3xl);
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: var(--space-2);
        }
        
        .auth-title {
            font-size: var(--text-2xl);
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: var(--space-2);
        }
        
        .auth-subtitle {
            color: var(--gray-600);
            font-size: var(--text-sm);
        }
        
        .auth-form {
            margin-top: var(--space-8);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-4);
        }
        
        .form-group {
            margin-bottom: var(--space-6);
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
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
        
        .form-input::placeholder,
        .form-textarea::placeholder {
            color: var(--gray-400);
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .auth-button {
            width: 100%;
            padding: var(--space-4);
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: var(--text-base);
            cursor: pointer;
            transition: all var(--transition-fast);
            margin-top: var(--space-6);
        }
        
        .auth-button:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow-lg);
        }
        
        .auth-button:active {
            transform: translateY(0);
        }
        
        .auth-footer {
            text-align: center;
            margin-top: var(--space-8);
            padding-top: var(--space-6);
            border-top: 1px solid var(--gray-200);
        }
        
        .auth-link {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: color var(--transition-fast);
        }
        
        .auth-link:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }
        
        .error-message {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
            padding: var(--space-3);
            border-radius: var(--radius-lg);
            margin-top: var(--space-4);
            font-size: var(--text-sm);
            font-weight: 500;
        }
        
        .success-message {
            background: #ecfdf5;
            color: #065f46;
            border: 1px solid #a7f3d0;
            padding: var(--space-3);
            border-radius: var(--radius-lg);
            margin-top: var(--space-4);
            font-size: var(--text-sm);
            font-weight: 500;
        }
        
        /* Responsive */
        @media (max-width: 640px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .auth-card {
                padding: var(--space-8);
                margin: var(--space-4);
            }
            
            .auth-container {
                padding: var(--space-2);
            }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <div class="auth-logo">NexusCommerce</div>
                <h1 class="auth-title">Create Account</h1>
                <p class="auth-subtitle">Join us and start your shopping journey</p>
            </div>

            <form method="post" action="register.jsp" class="auth-form">
                <div class="form-group full-width">
                    <label for="fullname" class="form-label">Full Name</label>
                    <input type="text" id="fullname" name="fullname" class="form-input" placeholder="Enter your full name" required>
                </div>

                <div class="form-group full-width">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input" placeholder="Enter your email" required>
                </div>

                <div class="form-group full-width">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Create a strong password" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="gender" class="form-label">Gender</label>
                        <select id="gender" name="gender" class="form-select" required>
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="dob" class="form-label">Date of Birth</label>
                        <input type="date" id="dob" name="dob" class="form-input" required>
                    </div>
                </div>

                <div class="form-group full-width">
                    <label for="phone" class="form-label">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-input" placeholder="Enter your phone number" required>
                </div>

                <div class="form-group full-width">
                    <label for="address" class="form-label">Address</label>
                    <textarea id="address" name="address" class="form-textarea" placeholder="Enter your address" rows="3"></textarea>
                </div>

                <div class="form-group full-width">
                    <label for="role" class="form-label">Account Type</label>
                    <select id="role" name="role" class="form-select" required>
                        <option value="User" selected>Customer</option>
                        <option value="Admin">Administrator</option>
                        <option value="Guest">Guest</option>
                    </select>
                </div>

                <button type="submit" class="auth-button">
                    Create Account
                </button>
            </form>

            <div class="auth-footer">
                <p>Already have an account? <a href="login.jsp" class="auth-link">Sign in here</a></p>
            </div>

            <%
                // Process registration only if form is submitted
                String fullname = request.getParameter("fullname");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String gender = request.getParameter("gender");
                String dob = request.getParameter("dob");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                String role = request.getParameter("role");

                if (fullname != null && email != null && password != null) {
                    Connection conn = null;
                    PreparedStatement ps = null;
                    try {
                        conn = DBConnection.getConnection();

                        // Check if email already exists
                        ps = conn.prepareStatement("SELECT * FROM users WHERE email=?");
                        ps.setString(1, email);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            out.println("<div class='error-message'>Email already exists! Please try with a different email address.</div>");
                        } else {
                            // Insert new user
                            ps = conn.prepareStatement(
                                "INSERT INTO users(fullname,email,password,gender,dob,phone,address,role) VALUES (?,?,?,?,?,?,?,?)"
                            );
                            ps.setString(1, fullname);
                            ps.setString(2, email);
                            ps.setString(3, password); // For simplicity, plain text (can use hashing later)
                            ps.setString(4, gender);
                            ps.setString(5, dob);
                            ps.setString(6, phone);
                            ps.setString(7, address);
                            ps.setString(8, role);

                            int rows = ps.executeUpdate();
                            if (rows > 0) {
                                out.println("<div class='success-message'>Registration successful! <a href='login.jsp' class='auth-link'>Click here to login</a></div>");
                            }
                        }
                    } catch (Exception e) {
                        out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
                        e.printStackTrace(); // ✅ Logs to server console
                    } finally {
                        try { if (ps != null) ps.close(); } catch (Exception ex) {}
                        try { if (conn != null) conn.close(); } catch (Exception ex) {}
                    }
                }
            %>
        </div>
    </div>
</body>
</html>