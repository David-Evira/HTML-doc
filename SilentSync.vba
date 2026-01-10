# PSEUDOCODE: SILENT_SYNC_WRAPPER (VBScript)

PURPOSE: 
    To execute the main Batch engine as a background process, 
    preventing the Command Prompt window from appearing to the end-user.

INITIALIZE:
    CREATE Windows Shell Object (WScript.Shell)

EXECUTE:
    DEFINE target_command = "SyncScrap.bat"
    
    # Run the command with the following parameters:
    # 0     -> Window Style: HIDDEN (Hidden from view)
    # False -> Wait On Return: OFF (Do not wait for the script to finish)
    
    CALL WshShell.Run(target_command, 0, False)

TERMINATE:
    Close Wrapper (Leaving the Batch engine running in system memory)
