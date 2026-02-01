@echo off
echo ========================================
echo   ABAP Lint Editor - Start Both Servers
echo ========================================
echo.
echo Starting Playground Server (Port 8090)...
start "Playground Server" cmd /k "cd /d C:\Users\q_zhang50374\Documents\abaplint\abaplint\web\playground && npm run dev"

timeout /t 3 /nobreak >nul

echo Starting UI5 Application (Port 8080)...
start "UI5 Application" cmd /k "cd /d C:\Users\q_zhang50374\Documents\abaplint\abaplint\web\project1 && npm start"

echo.
echo ========================================
echo Both servers are starting...
echo.
echo Playground: http://localhost:8090
echo UI5 App:    http://localhost:8080/index.html
echo.
echo Press any key to close this window...
pause >nul
