( Work in progress ) Master Scrap Sync System

Master Scrap Sync System is a background-processing synchronization and archival engine designed for industrial scrap logging environments.
It bridges a browser-based dashboard with the local Windows file system to automate:
- authoritative data saves
- background backups
- structured PDF archiving
The system is intentionally offline-first, serverless, and operator-safe, making it suitable for shop-floor and shared workstation use.

Key Design Goals
No database or server dependency
Single authoritative write node
Read-only replicas for visibility
Silent background operation
Clear failure detection and lockout behavior

Project Components
File	Purpose
ScrapLog.html	User-facing dashboard (UI)
START_APP.bat	Bootloader and startup orchestrator
SyncScrap.bat	Core synchronization engine
SilentSync.vbs	Runs the engine invisibly (no console window)
STOP_SYNC.bat	Emergency stop and cleanup utility

System Architecture Overview
The system is composed of three coordinated layers:
1. Startup Pipeline
2. Background Automation Engine
3. Dashboard UI

Each layer operates independently but communicates through a shared heartbeat protocol.

1. Startup Pipeline (START_APP.bat)
The startup script ensures the system always launches in a clean and verified state.
Startup Sequence
Cleanup
Terminates any existing sync processes
Deletes stale heartbeat.js files to prevent “ghost” status

Hidden Engine Launch

Starts SilentSync.vbs

Runs the sync engine invisibly in the background

Engine Verification

Waits until heartbeat.js is created

Confirms the engine is alive before continuing

UI Launch

Opens ScrapLog.html only after verification completes

This guarantees the dashboard never opens in an unsafe or partially initialized state.

2. Automation Engine (SyncScrap.bat)

The automation engine runs continuously in the background on a short interval.

Core Responsibilities

Heartbeat & Identity

Writes system heartbeat data every 2 seconds

Includes the current Windows %USERNAME% for permission checks

Data Synchronization

Detects SCRAP_EXPORT_DATA.txt in the user’s Downloads folder

Moves it into the local data store

Copies a backup to a configured network drive (if available)

Smart PDF Archiving

Detects exported PDF reports

Automatically organizes them into:

Scrap_History/
 └── [Year]/
     └── [Month]/
         └── [Week_Number]/


Date calculations are handled via PowerShell for accuracy.

3. Dashboard UI (ScrapLog.html)

The dashboard is a browser-based control and visibility layer.

UI Behavior

Heartbeat Monitoring

Checks for heartbeat.js every 2 seconds

If missing, displays a full-screen SYSTEM OFFLINE lockout

Permission Enforcement

Compares the active Windows user against a WHITELIST

Unauthorized users:

Cannot save

Cannot modify records

See disabled action controls

This enforces a single-writer / multi-reader authority model.

Core Logic (Pseudocode)
Background Sync Engine
INITIALIZE:
  source_data = Downloads/SCRAP_EXPORT_DATA.txt
  backup_path = USER_DEFINED_NETWORK_PATH
  archive_folder = ./Scrap_History

LOOP (Every 2 Seconds):
  WRITE "Active_Status + USERNAME" TO heartbeat.js

  IF source_data EXISTS:
      MOVE source_data TO local_database
      IF backup_path IS ACCESSIBLE:
          COPY local_database TO backup_path

  IF Exported_PDF EXISTS:
      CALCULATE Year, Month, Week_Number
      CREATE archive_folder IF NOT EXISTS
      MOVE PDF TO archive_folder

Dashboard Logic
FUNCTION checkHeartbeat():
  TRY load heartbeat.js
    IF success:
        HIDE lockout screen
        VERIFY user against WHITELIST
        IF unauthorized:
            DISABLE action buttons
    IF failure:
        SHOW "SYSTEM OFFLINE" lockout screen

Setup & Installation

Clone this repository to a local folder

Open ScrapLog.html

Add authorized Windows usernames to the WHITELIST array

Open SyncScrap.bat

Set G_DRIVE_BACKUP to your network share path

Run START_APP.bat

The system will:

launch silently

verify engine health

open the dashboard automatically

Notes

This system is intentionally minimal by design.
Complexity was avoided where it did not improve reliability, safety, or usability.
