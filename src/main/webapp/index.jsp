<%-- 
    Document   : index
    Author     : SATYAM KUMAR
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    // Temporarily disabled for testing - uncomment the lines below for production
    // if (userEmail == null) {
    //     response.sendRedirect("login.jsp");
    //     return;
    // }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NexusCommerce - Premium Shopping Experience</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        /* Hero Section */
        .hero {
            background: var(--bg-gradient);
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero::before {
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
        
        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
            color: white;
            max-width: 800px;
            margin: 0 auto;
            padding: var(--space-8);
        }
        
        .hero h1 {
            font-size: var(--text-5xl);
            font-weight: 800;
            margin-bottom: var(--space-6);
            text-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            animation: fadeIn 1s ease-out;
        }
        
        .hero p {
            font-size: var(--text-xl);
            margin-bottom: var(--space-8);
            opacity: 0.95;
            animation: fadeIn 1s ease-out 0.2s both;
        }
        
        .hero-cta {
            display: flex;
            gap: var(--space-4);
            justify-content: center;
            flex-wrap: wrap;
            animation: fadeIn 1s ease-out 0.4s both;
        }
        
        .hero-cta .btn {
            padding: var(--space-4) var(--space-8);
            font-size: var(--text-lg);
            font-weight: 600;
        }
        
        .hero-cta .btn-primary {
            background: white;
            color: var(--primary-color);
            box-shadow: var(--shadow-xl);
        }
        
        .hero-cta .btn-primary:hover {
            background: var(--gray-100);
            transform: translateY(-2px);
        }
        
        .hero-cta .btn-outline {
            border-color: white;
            color: white;
        }
        
        .hero-cta .btn-outline:hover {
            background: white;
            color: var(--primary-color);
        }
        
        /* Features Section */
        .features {
            padding: var(--space-20) 0;
            background: var(--bg-primary);
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: var(--space-8);
            margin-top: var(--space-12);
        }
        
        .feature-card {
            text-align: center;
            padding: var(--space-8);
            border-radius: var(--radius-2xl);
            background: var(--bg-secondary);
            border: 1px solid var(--gray-200);
            transition: all var(--transition-normal);
        }
        
        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-xl);
            border-color: var(--primary-color);
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto var(--space-6);
            background: var(--primary-color);
            border-radius: var(--radius-full);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: var(--text-3xl);
            color: white;
        }
        
        .feature-card h3 {
            font-size: var(--text-xl);
            margin-bottom: var(--space-4);
            color: var(--gray-900);
        }
        
        .feature-card p {
            color: var(--gray-600);
            line-height: 1.6;
        }
        
        /* Stats Section */
        .stats {
            background: var(--gray-900);
            color: white;
            padding: var(--space-20) 0;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--space-8);
            text-align: center;
        }
        
        .stat-item h3 {
            font-size: var(--text-4xl);
            font-weight: 800;
            color: var(--primary-light);
            margin-bottom: var(--space-2);
        }
        
        .stat-item p {
            font-size: var(--text-lg);
            opacity: 0.9;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: var(--text-4xl);
            }
            
            .hero p {
                font-size: var(--text-lg);
            }
            
            .hero-cta {
                flex-direction: column;
                align-items: center;
            }
            
            .hero-cta .btn {
                width: 100%;
                max-width: 300px;
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
                    <li><a href="index.jsp" class="active">Home</a></li>
                    <li><a href="products.jsp">Products</a></li>
                    <li><a href="cart.jsp">Cart</a></li>
                    <li><a href="myOrders.jsp">My Orders</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Welcome to NexusCommerce</h1>
            <p>Discover premium products with an exceptional shopping experience. Quality, convenience, and style all in one place.</p>
            <div class="hero-cta">
                <a href="products.jsp" class="btn btn-primary">Shop Now</a>
                <a href="myOrders.jsp" class="btn btn-outline">View Orders</a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <div class="text-center">
                <h2>Why Choose NexusCommerce?</h2>
                <p class="text-lg">Experience shopping redefined with our premium features</p>
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">🚀</div>
                    <h3>Fast Delivery</h3>
                    <p>Get your orders delivered quickly with our express shipping options across the country.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🔒</div>
                    <h3>Secure Payments</h3>
                    <p>Shop with confidence using our secure payment gateway and fraud protection systems.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">⭐</div>
                    <h3>Premium Quality</h3>
                    <p>Curated selection of high-quality products from trusted brands and verified sellers.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🎯</div>
                    <h3>Easy Returns</h3>
                    <p>Hassle-free returns and exchanges within 30 days of purchase for your peace of mind.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item">
                    <h3>10K+</h3>
                    <p>Happy Customers</p>
                </div>
                <div class="stat-item">
                    <h3>50K+</h3>
                    <p>Products Available</p>
                </div>
                <div class="stat-item">
                    <h3>99%</h3>
                    <p>Customer Satisfaction</p>
                </div>
                <div class="stat-item">
                    <h3>24/7</h3>
                    <p>Customer Support</p>
                </div>
            </div>
        </div>
    </section>
</body>
</html>