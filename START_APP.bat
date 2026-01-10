# PSEUDOCODE: START_SYSTEM

PURPOSE:
    To ensure a clean environment, launch the hidden synchronization 
    engine, and only open the user interface once the engine is verified active.

INITIALIZE:
    Set working directory to script location

STEP 1: CLEAN ENVIRONMENT
    FIND and KILL any existing "SCRAP_SYNC_TASK" processes
    (Prevents duplicate engines from running simultaneously)
    
    IF heartbeat.js exists: 
        DELETE heartbeat.js
        (Ensures we don't detect a "false active" status from a previous session)

STEP 2: LAUNCH ENGINE
    EXECUTE "SilentSync.vbs"
    (This starts the main engine in the background without a visible window)

STEP 3: ACTIVE VERIFICATION (Heartbeat Check)
    LOOP:
        CHECK if heartbeat.js has been created
        IF NOT FOUND:
            WAIT 1 second
            RETRY CHECK
        IF FOUND:
            BREAK LOOP
    (This ensures the Dashboard never opens in 'Offline Mode' during startup)

STEP 4: LAUNCH INTERFACE
    OPEN "ScrapLog.html" in the default web browser

TERMINATE:
    CLOSE Bootloader (Background engine remains running)
