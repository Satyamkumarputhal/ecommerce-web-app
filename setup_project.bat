@echo off
echo =========================================
echo     ECOMMERCE APPLICATION SETUP
echo =========================================
echo.

echo [1/5] Checking Java Installation...
java -version
if %errorlevel% neq 0 (
    echo ERROR: Java is not installed or not in PATH
    echo Please install JDK and add to PATH
    pause
    exit /b 1
)
echo Java found successfully!
echo.

echo [2/5] Checking Maven Installation...
mvn -version
if %errorlevel% neq 0 (
    echo ERROR: Maven is not installed or not in PATH
    echo Please install Maven and add to PATH
    pause
    exit /b 1
)
echo Maven found successfully!
echo.

echo [3/5] Cleaning previous builds...
echo Running: mvn clean
mvn clean
echo.

echo [4/5] Installing project dependencies...
echo Running: mvn dependency:resolve
mvn dependency:resolve
if %errorlevel% neq 0 (
    echo ERROR: Failed to resolve dependencies
    pause
    exit /b 1
)
echo.

echo [5/5] Compiling and packaging application...
echo Running: mvn compile package
mvn compile package
if %errorlevel% neq 0 (
    echo ERROR: Failed to compile application
    pause
    exit /b 1
)
echo.

echo =========================================
echo     SETUP COMPLETED SUCCESSFULLY!
echo =========================================
echo.
echo WAR file created at: target\ecommerce-web.war
echo.
echo Next steps:
echo 1. Run 'check_database.bat' to verify database connection
echo 2. Run 'start_server.bat' to start the web server
echo.
pause