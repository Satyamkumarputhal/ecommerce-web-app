@echo off
echo =========================================
echo     DATABASE SCHEMA IMPORT
echo =========================================
echo.

echo This script will import the database schema into MySQL
echo Make sure MySQL server is running before proceeding
echo.

if not exist "create_database_schema.sql" (
    echo ERROR: create_database_schema.sql not found!
    echo Please make sure the file exists in the current directory
    pause
    exit /b 1
)

echo Checking MySQL client availability...
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: MySQL command line client not found in PATH
    echo Please install MySQL and add it to your PATH
    echo Alternatively, use MySQL Workbench to run the script manually
    pause
    exit /b 1
)

echo.
echo Importing database schema...
echo Please enter your MySQL root password when prompted:
echo.

mysql -u root -p < create_database_schema.sql

if %errorlevel% equ 0 (
    echo.
    echo SUCCESS: Database schema imported successfully!
    echo.
    echo The following has been created:
    echo - Database: ecommerce_db
    echo - Tables: users, products, orders, order_items
    echo - Sample data including admin user and products
    echo.
    echo Default login credentials:
    echo - Admin: admin@ecommerce.com / admin123
    echo - User: john@email.com / john123
) else (
    echo.
    echo ERROR: Failed to import database schema
    echo Please check:
    echo 1. MySQL server is running
    echo 2. Root password is correct
    echo 3. You have permissions to create databases
)

echo.
pause