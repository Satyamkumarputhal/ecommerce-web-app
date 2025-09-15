@echo off
echo =========================================
echo     DATABASE CONNECTION CHECK
echo =========================================
echo.

echo Checking if dependencies are available...
if not exist "target\dependency" (
    echo ERROR: Dependencies not found. Please run 'setup_project.bat' first
    pause
    exit /b 1
)

echo Compiling database connection test...
javac -cp "target\classes;target\dependency\*" src\main\java\com\ecommerce\DBConnection.java -d target\classes

if %errorlevel% neq 0 (
    echo ERROR: Failed to compile DBConnection.java
    echo Make sure you have run setup_project.bat first
    pause
    exit /b 1
)

echo Creating database connection test...
echo import com.ecommerce.DBConnection; > DBTest.java
echo import java.sql.Connection; >> DBTest.java
echo. >> DBTest.java
echo public class DBTest { >> DBTest.java
echo     public static void main(String[] args) { >> DBTest.java
echo         System.out.println("Testing database connection..."); >> DBTest.java
echo         try { >> DBTest.java
echo             Connection conn = DBConnection.getConnection(); >> DBTest.java
echo             if (conn != null) { >> DBTest.java
echo                 System.out.println("SUCCESS: Database connected successfully!"); >> DBTest.java
echo                 conn.close(); >> DBTest.java
echo                 System.out.println("Connection closed properly."); >> DBTest.java
echo             } else { >> DBTest.java
echo                 System.out.println("ERROR: Failed to establish connection"); >> DBTest.java
echo             } >> DBTest.java
echo         } catch (Exception e) { >> DBTest.java
echo             System.out.println("ERROR: " + e.getMessage()); >> DBTest.java
echo             e.printStackTrace(); >> DBTest.java
echo         } >> DBTest.java
echo     } >> DBTest.java
echo } >> DBTest.java

echo Compiling test class...
javac -cp "target\classes;target\dependency\*" DBTest.java

echo Running database connection test...
java -cp ".;target\classes;target\dependency\*" DBTest

echo.
echo Cleaning up test files...
del DBTest.java
del DBTest.class

echo.
echo =========================================
echo     DATABASE CONNECTION TEST COMPLETE
echo =========================================
echo.
echo If you see "SUCCESS" above, your database is properly configured.
echo If you see errors, please check:
echo 1. MySQL service is running
echo 2. Database 'ecommerce_db' exists (run the SQL script)
echo 3. Username/password in DBConnection.java are correct
echo.
pause