# PSEUDOCODE: STOP_SCRAP_SYNC

PURPOSE:
    To gracefully terminate background synchronization and 
    immediately trigger the UI lockout mechanism.

CHECK STATUS:
    SCAN active system processes for "SCRAP_SYNC_TASK"
    
    IF task is NOT FOUND:
        DISPLAY "System already offline"
        IF heartbeat.js exists: DELETE heartbeat.js (Cleanup stray files)
        EXIT
        
    ELSE (Task is running):
        DISPLAY "Terminating background tasks..."

        # --- STEP 1: UI LOCKOUT ---
        DELETE heartbeat.js
        (We do this first so the web UI locks buttons immediately)
        
        WAIT 1 second (Allow file system to release locks)
        
        IF heartbeat.js STILL EXISTS:
            FORCE DELETE heartbeat.js (Override read-only/lock)

        # --- STEP 2: PROCESS TERMINATION ---
        FORCE KILL process with window title "SCRAP_SYNC_TASK"
        
        # --- STEP 3: FINAL VERIFICATION ---
        WAIT 1 second
        IF heartbeat.js exists:
            RETRY FORCE DELETE heartbeat.js
            
        DISPLAY "System Offline: Heartbeat removed and process terminated"

FINALIZE:
    PAUSE to allow user to read status
    EXIT
