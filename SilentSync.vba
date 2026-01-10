' Master Scrap Sync - Background Execution Wrapper
' This script launches the batch engine in a hidden state.

Set WshShell = CreateObject("WScript.Shell")

' Parameters:
' chr(34) is a double quote, used to handle potential spaces in file paths.
' 0       tells Windows to run the window HIDDEN.
' False   tells the script NOT to wait for the batch file to finish before closing itself.

WshShell.Run chr(34) & "SyncScrap.bat" & chr(34), 0, False

Set WshShell = Nothing
