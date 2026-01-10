@echo off
cd /d "%~dp0"

:: 1. Kill any old sync tasks
taskkill /FI "WINDOWTITLE eq SCRAP_SYNC_TASK*" /F >nul 2>&1

:: 2. Delete old heartbeat so we know we're starting fresh
if exist "heartbeat.js" del /q "heartbeat.js"

:: 3. Launch the HIDDEN engine
start "" wscript.exe "SilentSync.vbs"

:: 4. WAIT for the engine to create the first heartbeat file
:wait_for_engine
if not exist "heartbeat.js" (
    timeout /t 1 /nobreak >nul
    goto wait_for_engine
)

:: 5. Now that the engine is confirmed alive, launch the Dashboard
start "" "ScrapLog.html"

exit
