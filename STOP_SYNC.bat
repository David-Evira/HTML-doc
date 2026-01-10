@echo off
title STOP_SCRAP_SYNC
cd /d "%~dp0"

echo [CHECKING] System status...

:: Check if the sync task is actually running
tasklist /FI "WINDOWTITLE eq SCRAP_SYNC_TASK*" | find /i "cmd.exe" >nul
if errorlevel 1 (
    echo [INFO] Sync Task not found. Checking for stray heartbeat...
    if exist "heartbeat.js" del /q "heartbeat.js"
    echo [SUCCESS] System is already OFFLINE.
) else (
    echo [TERMINATING] Stopping Scrap Sync background tasks...

    :: 1. Delete heartbeat FIRST to trigger immediate HTML lockout
    :: We use a loop to ensure it's deleted even if the file is momentarily locked
    del /q "heartbeat.js" >nul 2>&1
    timeout /t 1 /nobreak >nul
    if exist "heartbeat.js" del /f /q "heartbeat.js"

    :: 2. Force kill the background process
    taskkill /FI "WINDOWTITLE eq SCRAP_SYNC_TASK*" /F >nul 2>&1
    
    :: 3. Final verification of cleanup
    if exist "heartbeat.js" (
        echo [RETRY] Forcing heartbeat removal...
        timeout /t 1 /nobreak >nul
        del /f /q "heartbeat.js"
    )

    echo [SUCCESS] Heartbeat removed and Process terminated.
    echo System is now OFFLINE.
)

pause
