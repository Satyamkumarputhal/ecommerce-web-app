@echo off
title Ecommerce Application - Quick Start
color 0A

echo.
echo  ███████╗ ██████╗ ██████╗ ███╗   ███╗███╗   ███╗███████╗██████╗  ██████╗███████╗
echo  ██╔════╝██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔════╝██╔══██╗██╔════╝██╔════╝
echo  █████╗  ██║     ██║   ██║██╔████╔██║██╔████╔██║█████╗  ██████╔╝██║     █████╗  
echo  ██╔══╝  ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══╝  ██╔══██╗██║     ██╔══╝  
echo  ███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║███████╗██║  ██║╚██████╗███████╗
echo  ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚══════╝
echo.
echo                              QUICK START MENU
echo  ==================================================================================
echo.

:menu
echo  Please select an option:
echo.
echo  [1] First Time Setup (Install dependencies + Build project)
echo  [2] Import Database Schema (Create tables and sample data)
echo  [3] Test Database Connection (Simple MySQL test)
echo  [4] Test Database Connection (Java-based test)
echo  [5] Start Web Server
echo  [6] Open Frontend in Browser
echo  [7] View Setup Instructions
echo  [8] Exit
echo.
set /p choice="Enter your choice (1-8): "

if "%choice%"=="1" goto setup
if "%choice%"=="2" goto import_db
if "%choice%"=="3" goto mysql_test
if "%choice%"=="4" goto dbtest
if "%choice%"=="5" goto server
if "%choice%"=="6" goto frontend
if "%choice%"=="7" goto instructions
if "%choice%"=="8" goto exit
goto invalid

:setup
echo.
echo =========================================
echo  RUNNING FIRST TIME SETUP...
echo =========================================
call setup_project.bat
echo.
echo Setup completed! Press any key to return to menu...
pause >nul
goto menu

:import_db
echo.
echo =========================================
echo  IMPORTING DATABASE SCHEMA...
echo =========================================
call import_database.bat
echo.
echo Import completed! Press any key to return to menu...
pause >nul
goto menu

:mysql_test
echo.
echo =========================================
echo  TESTING MYSQL CONNECTION...
echo =========================================
call test_mysql.bat
echo.
echo Test completed! Press any key to return to menu...
pause >nul
goto menu

:dbtest
echo.
echo =========================================
echo  TESTING DATABASE CONNECTION...
echo =========================================
call check_database.bat
echo.
echo Test completed! Press any key to return to menu...
pause >nul
goto menu

:server
echo.
echo =========================================
echo  STARTING WEB SERVER...
echo =========================================
echo.
echo NOTE: Server will start and this window will be dedicated to it.
echo Use Ctrl+C to stop the server when needed.
echo.
pause
call start_server.bat
goto menu

:frontend
echo.
echo =========================================
echo  OPENING FRONTEND...
echo =========================================
call open_frontend.bat
echo.
echo Frontend opened! Press any key to return to menu...
pause >nul
goto menu

:instructions
echo.
echo =========================================
echo  SETUP INSTRUCTIONS
echo =========================================
echo.
echo 1. PREREQUISITES:
echo    - JDK 24 (installed)
echo    - Maven (installed)  
echo    - MySQL Server (installed)
echo.
echo 2. FIRST TIME SETUP:
echo    - Run option [1] to install dependencies and build
echo    - Import 'create_database_schema.sql' into MySQL
echo    - Run option [2] to test database connection
echo.
echo 3. RUNNING APPLICATION:
echo    - Run option [3] to start web server
echo    - Run option [4] to open in browser
echo    - Access: http://localhost:8080/ecommerce-web/
echo.
echo 4. DEFAULT LOGIN:
echo    - Email: admin@ecommerce.com
echo    - Password: admin123
echo.
echo Press any key to return to menu...
pause >nul
goto menu

:invalid
echo.
echo Invalid choice! Please select 1-8.
echo.
goto menu

:exit
echo.
echo Thank you for using Ecommerce Application!
echo.
exit /b 0