# PSEUDOCODE: SCRAP_SYNC_TASK

INITIALIZE:
    Set working directory to script location
    IF heartbeat_file exists: DELETE heartbeat_file
    
    DEFINE source_data_path      = Downloads/SCRAP_EXPORT_DATA.txt
    DEFINE source_pdf_pattern    = Downloads/ScrapLog_Export_*.pdf
    DEFINE local_database        = CurrentFolder/scrap_data.js
    DEFINE backup_destination    = G:/Shared_Drive/Tools/scrap_data.js
    DEFINE archive_base_folder   = CurrentFolder/Scrap_History

LOOP (Continuous Execution):
    
    # --- HEARTBEAT SYSTEM ---
    GET Current_Windows_Username
    WRITE "System_Active = True, User = [Username]" TO heartbeat.js
    (This allows the UI to verify the background engine is running and check permissions)

    # --- 1. DATA SYNCHRONIZATION ---
    IF source_data_path EXISTS:
        DISPLAY "New data found"
        MOVE source_data_path TO local_database (Overwrite existing)
        UNBLOCK local_database (Security bypass for browser access)
        
        IF backup_destination path IS ACCESSIBLE:
            COPY local_database TO backup_destination
            DISPLAY "External Backup Complete"
            
        DELETE any remaining SCRAP_EXPORT_DATA temporary files in Downloads
        DISPLAY "Local Database Updated"

    # --- 2. PDF ARCHIVAL & DATE SORTING ---
    IF source_pdf_pattern EXISTS:
        DISPLAY "New PDF found"
        
        # Calculate Date-Based Folder Structure
        GET Current_Year
        GET Current_Month_Name
        GET Current_Week_Of_Year (ISO-8601 Standard)
        
        SET target_path = archive_base_folder / Year / Month / Week
        
        IF target_path DOES NOT EXIST:
            CREATE target_path
            
        MOVE source_pdf_pattern TO target_path
        DISPLAY "PDF archived to: " + target_path

    # --- WAIT PERIOD ---
    PAUSE for 2 seconds
    REPEAT LOOP
