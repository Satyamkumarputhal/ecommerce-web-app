@echo off
echo =========================================
echo     OPENING ECOMMERCE FRONTEND
echo =========================================
echo.

echo Checking if server is running...
curl -s http://localhost:8080/ecommerce-web/ >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Server doesn't seem to be running at http://localhost:8080/ecommerce-web/
    echo Please make sure you have started the server using 'start_server.bat'
    echo.
    echo Do you want to continue opening the browser anyway? (Y/N)
    set /p continue=
    if /i "%continue%" neq "Y" (
        exit /b 0
    )
)

echo Opening application in your default browser...
echo URL: http://localhost:8080/ecommerce-web/
echo.

start http://localhost:8080/ecommerce-web/

echo.
echo Available pages:
echo - Home: http://localhost:8080/ecommerce-web/
echo - Login: http://localhost:8080/ecommerce-web/login.jsp
echo - Register: http://localhost:8080/ecommerce-web/register.jsp
echo - Products: http://localhost:8080/ecommerce-web/products.jsp
echo.
echo Browser opened successfully!
pause