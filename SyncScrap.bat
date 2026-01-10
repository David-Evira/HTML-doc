@echo off
title SCRAP_SYNC_TASK
:: Set working directory to the current folder
cd /d "%~dp0"

:: Initial cleanup of status files
if exist "heartbeat.js" del /q "heartbeat.js"

:: --- CONFIGURATION ---
:: Define the paths for source files and destinations
set "DL_DATA=%USERPROFILE%\Downloads\SCRAP_EXPORT_DATA.txt"
set "DL_PDF_PATTERN=%USERPROFILE%\Downloads\ScrapLog_Export_*.pdf"
set "DEST_DATA=%~dp0scrap_data.js"

:: REPLACE THIS PATH with your actual network or local backup location
set "BACKUP_DIR=C:\Backup_Destination"
set "BASE_PDF_DIR=%~dp0Scrap_History"

echo [STARTING] Background engine active...

:loop
:: --- 1. HEARTBEAT SYSTEM ---
:: Periodically write status and current user to a JS file for the Dashboard UI
echo var systemActive = true; var currentUser = "%USERNAME%"; > "heartbeat.js"

:: --- 2. DATA SYNCHRONIZATION ---
:: Check for new data exports in the Downloads folder
if exist "%DL_DATA%" (
    echo [FOUND NEW DATA] Processing and backing up...
    
    :: Move to local database
    move /y "%DL_DATA%" "%DEST_DATA%"
    
    :: Security: Unblock the file to ensure the browser can read it as a script
    powershell -Command "Unblock-File -Path '%DEST_DATA%'"
    
    :: External Backup
    if exist "%BACKUP_DIR%" (
        copy /y "%DEST_DATA%" "%BACKUP_DIR%\scrap_data.js" >nul
        echo [SUCCESS] Network Backup Complete.
    )
    
    :: Cleanup any temporary download naming variants
    del /q "%USERPROFILE%\Downloads\SCRAP_EXPORT_DATA*.txt" >nul 2>&1
)

:: --- 3. AUTOMATED PDF ARCHIVING ---
:: Check for exported PDF reports
if exist "%DL_PDF_PATTERN%" (
    echo [FOUND PDF] Calculating date-based folder structure...
    
    :: Use PowerShell to calculate Year, Month Name, and Week Number (ISO Standard)
    for /f "tokens=1-3" %%A in ('powershell -Command "Get-Date -uformat '%%Y %%B'; $c=(Get-Culture).Calendar; $d=Get-Date; $w=$c.GetWeekOfYear($d,[System.Globalization.CalendarWeekRule]::FirstFourDayWeek,[DayOfWeek]::Sunday); if($w -lt 10){'0'+$w}else{$w}"') do (
        set "curYear=%%A"
        set "curMonth=%%B"
        set "curWeek=Week %%C"
    )
    
    :: Build the nested directory path
    set "TARGET_DIR=%BASE_PDF_DIR%\%curYear%\%curMonth%\%curWeek%"
    
    :: Create directory if it doesn't exist
    if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"
    
    :: Move PDF to the final archive
    move /y "%DL_PDF_PATTERN%" "%TARGET_DIR%\"
    echo [SUCCESS] PDF Archived to: %TARGET_DIR%
)

:: Wait 2 seconds before the next check to preserve CPU resources
timeout /t 2 >nul
goto loop
