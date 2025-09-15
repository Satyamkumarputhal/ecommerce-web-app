@echo off
echo =========================================
echo     SIMPLE DATABASE CONNECTION TEST
echo =========================================
echo.

echo Checking if MySQL service is running...
echo This will test MySQL connectivity using built-in tools
echo.

echo Testing MySQL connection with ping...
timeout /t 2 >nul

echo Attempting to connect to MySQL server...
mysql --version >nul 2>&1
if %errorlevel% equ 0 (
    echo MySQL client found. Testing connection...
    echo.
    echo Please enter your MySQL password when prompted:
    mysql -u root -p -e "SELECT 'Database connection successful!' as Status; SHOW DATABASES LIKE 'ecommerce_db';"
    if %errorlevel% equ 0 (
        echo.
        echo SUCCESS: MySQL connection is working!
    ) else (
        echo.
        echo ERROR: Failed to connect to MySQL
        echo Please check:
        echo 1. MySQL service is running
        echo 2. Username/password are correct
        echo 3. Database 'ecommerce_db' exists
    )
) else (
    echo MySQL command line client not found in PATH
    echo.
    echo Alternative: Test using Java (requires setup_project.bat to be run first)
    echo Would you like to run the Java-based test? (Y/N)
    set /p choice=
    if /i "%choice%"=="Y" (
        call check_database.bat
    )
)

echo.
echo =========================================
echo     SIMPLE DATABASE TEST COMPLETE
echo =========================================
pause