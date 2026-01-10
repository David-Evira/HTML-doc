Master Scrap Sync System
A background-processing synchronization and archival engine for industrial scrap logging. This system bridges a browser-based dashboard with the local file system to automate data backups and PDF document organization.

🛠 Project Components
ScrapLog.html: The user interface (The Dashboard).
START_APP.bat: The bootloader that initializes the environment.
SyncScrap.bat: The core engine (Logic) that monitors files.
SilentSync.vbs: A wrapper that runs the engine invisibly.
STOP_SYNC.bat: The emergency stop and cleanup utility.

🏗 System Architecture
1. The Startup Pipeline (START_APP.bat)
Initialization: Kills existing instances and deletes old heartbeat files to prevent "ghost" processes.
Hidden Execution: Launches SilentSync.vbs, triggering the engine in a hidden window.
Verification: Waits for heartbeat.js before opening the Dashboard to ensure zero-latency connectivity.

2. The Automation Engine (SyncScrap.bat)
Runs a continuous loop (every 2 seconds):
Heartbeat & Security: Writes the current Windows %USERNAME% to heartbeat.js.
Data Sync: Detects SCRAP_EXPORT_DATA.txt in Downloads, moves it to the local database, and copies a backup to a configured Network Drive.
Smart Archiving: Detects PDF exports and organizes them into: Scrap_History/[Year]/[Month]/[Week_Number].

4. The Dashboard UI (ScrapLog.html)
Monitoring: Checks for the heartbeat every 2s. If missing, a "SYSTEM OFFLINE" lockout screen triggers.
Permissions: Compares user ID against a WHITELIST. Unauthorized users have action buttons disabled.

🧠 Technical Logic (Pseudocode)
Core Sync Engine

INITIALIZE:
    SET source_data    = Downloads/SCRAP_EXPORT_DATA.txt
    SET backup_path    = [USER_DEFINED_NETWORK_PATH]
    SET archive_folder = ./Scrap_History

LOOP (Every 2 Seconds):
    WRITE "Active_Status and %USERNAME%" TO heartbeat.js

    IF source_data EXISTS:
        MOVE source_data TO local_database
        IF backup_path IS ACCESSIBLE:
            COPY local_database TO backup_path

    IF Exported_PDF EXISTS:
        CALCULATE [Year], [Month], [Week_Number] via PowerShell
        CREATE target_directory IF NOT EXISTS
        MOVE PDF TO target_directory
Dashboard UI Logic

FUNCTION checkHeartbeat():
    TRY to load 'heartbeat.js'
    IF SUCCESS:
        HIDE Lockout Overlay
        VERIFY currentUser against WHITELIST
    IF FAIL:
        SHOW "SYSTEM OFFLINE" Overlay
        DISABLE Action Buttons
        
🚀 Setup & Installation
Clone this repository to a local directory.
Open ScrapLog.html and add authorized Windows IDs to the WHITELIST array.
Edit SyncScrap.bat and set the G_DRIVE_BACKUP variable to your network share path.
Run START_APP.bat to launch the system.
