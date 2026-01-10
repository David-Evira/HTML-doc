@echo off
:: Set working directory to the folder where this script is located
cd /d "%~dp0"

:: 1. Cleanup: Terminate any orphaned synchronization tasks from previous sessions
:: This looks for a window title matching our core engine's ID
taskkill /FI "WINDOWTITLE eq SCRAP_SYNC_TASK*" /F >nul 2>&1

:: 2. Reset Status: Delete the heartbeat file to ensure a clean handshake
if exist "heartbeat.js" del /q "heartbeat.js"

:: 3. Execution: Launch the background engine invisibly using the VBScript wrapper
start "" wscript.exe "SilentSync.vbs"

:: 4. Verification Loop: Wait for the engine to initialize and create the heartbeat
:wait_for_engine
if not exist "heartbeat.js" (
    timeout /t 1 /nobreak >nul
    goto wait_for_engine
)

:: 5. Launch: Once the engine is verified as ACTIVE, open the Dashboard
start "" "ScrapLog.html"

exit
