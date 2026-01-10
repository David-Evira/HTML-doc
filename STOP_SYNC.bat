@echo off
title STOP_SCRAP_SYNC
:: Set working directory to the current folder
cd /d "%~dp0"

echo [CHECKING] System status...

:: Check if the background sync task is currently active in system memory
tasklist /FI "WINDOWTITLE eq SCRAP_SYNC_TASK*" | find /i "cmd.exe" >nul

if errorlevel 1 (
    echo [INFO] Sync Task not found. Checking for stray heartbeat...
    if exist "heartbeat.js" del /q "heartbeat.js"
    echo [SUCCESS] System is already OFFLINE.
) else (
    echo [TERMINATING] Stopping background synchronization tasks...

    :: 1. UI LOCKOUT: Delete heartbeat FIRST. 
    :: This triggers the HTML Dashboard to immediately lock the screen 
    :: so the user cannot try to save data while the engine is shutting down.
    del /q "heartbeat.js" >nul 2>&1
    timeout /t 1 /nobreak >nul
    if exist "heartbeat.js" del /f /q "heartbeat.js"

    :: 2. PROCESS TERMINATION: Force kill the background engine
    taskkill /FI "WINDOWTITLE eq SCRAP_SYNC_TASK*" /F >nul 2>&1
    
    :: 3. CLEANUP: Final verification to ensure no status files remain
    if exist "heartbeat.js" (
        echo [RETRY] Forcing heartbeat removal...
        timeout /t 1 /nobreak >nul
        del /f /q "heartbeat.js"
    )

    echo [SUCCESS] Handshake files removed and process terminated.
    echo System is now OFFLINE.
)

pause
