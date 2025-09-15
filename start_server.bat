@echo off
echo =========================================
echo     STARTING ECOMMERCE WEB SERVER
echo =========================================
echo.

echo Checking if WAR file exists...
if not exist "target\ecommerce-web-1.0.0.war" (
    echo ERROR: WAR file not found!
    echo Please run 'setup_project.bat' first to build the application
    pause
    exit /b 1
)

echo Checking Maven installation...
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Maven not found. Please install Maven first.
    pause
    exit /b 1
)

echo.
echo Starting embedded Tomcat server...
echo Server will be available at: http://localhost:8080/ecommerce-web
echo.
echo Press Ctrl+C to stop the server
echo =========================================
echo.

mvn org.apache.tomcat.maven:tomcat7-maven-plugin:2.2:run

echo.
echo Server stopped.
pause