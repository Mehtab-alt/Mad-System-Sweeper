@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: #############################################################################
:: # Mad System Sweeper      - A Modular System Maintenance Framework      #
:: #############################################################################
:: # Core Insight: Script as a "Digital Dry Dock"                            #
:: # This script provides a structured, multi-stage facility for system      #
:: # maintenance, separating configuration from execution logic for safety   #
:: #############################################################################


:: =============================================================================
:: >> CONFIGURATION HUB << (Customize your cleaning operations here)
:: =============================================================================

:: --- Phase Switches (Set to TRUE to run a phase, FALSE to skip) ---
SET "RUN_PHASE_1_CORE_OPS=TRUE"
SET "RUN_PHASE_2_FILE_CLEANUP=TRUE"
SET "RUN_PHASE_3_MAINTENANCE=TRUE"
SET "RUN_PHASE_4_APP_DATA=TRUE"

:: --- Phase 1: Core Operations Configuration ---
SET "ProcessesToKill=msi.exe wuauclt.exe sihclient.exe TiWorker.exe trustedinstaller.exe MoUsoCoreWorker.exe UsoClient.exe usocoreworker.exe"
SET "ServicesToStop=bits cryptSvc DoSvc EventLog msiserver UsoSvc winmgmt wuauserv"

:: --- Phase 4: Application Data Backup Configuration ---
SET "AppDataSourceDrive=Z:"
SET "AppDataBackupDestBase=D:\OneDrive\Soft"
SET "AppSettingsBackupDestBase=D:\OneDrive\Setup\Users\Tairi\AppData\Roaming"
SET "BrowsersToBackup=Brave Edge Librewolf"
SET "BrowsersToKill=brave.exe msedge.exe librewolf.exe"
SET "AppSettingsToBackup=PotPlayerMini64 SystemInformer Wise Disk Cleaner Wise Registry Cleaner"

:: =============================================================================
:: Script Initialization and Pre-Flight Checks
:: =============================================================================

CHCP 65001 >nul
TITLE Mad System Sweeper

:PreFlightChecks
CLS
ECHO Verifying permissions...
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO  ============================================================
    ECHO   ERROR: Administrator privileges are required.
    ECHO   Please right-click the script and select "Run as administrator".
    ECHO  ============================================================
    ECHO.
    PAUSE
    GOTO :EOF
)


:: =============================================================================
:: Main Menu
:: =============================================================================

:MainMenu
mode 70,28
CLS
ECHO.
ECHO.
ECHO     ▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
ECHO     ▐                      Mad System Sweeper                    ▌
ECHO     ▐------------------------------------------------------------▌
ECHO     ▐                                                            ▌
ECHO     ▐   Welcome! This script performs a comprehensive, modular    ▌
ECHO     ▐   system cleaning and maintenance overhaul on your PC.     ▌
ECHO     ▐                                                            ▌
ECHO     ▐   --------------------- VERY IMPORTANT ------------------  ▌
ECHO     ▐                                                            ▌
ECHO     ▐   (1) USE THIS SCRIPT ENTIRELY AT YOUR OWN RISK.           ▌
ECHO     ▐   (2) ALWAYS BACKUP YOUR CRITICAL DATA before proceeding.  ▌
ECHO     ▐   (3) Administrator privileges have been confirmed.        ▌
ECHO     ▐   (4) DESTRUCTIVE actions (e.g., Restore Point deletion)   ▌
ECHO     ▐                                                            ▌
ECHO     ▐   -------------------------------------------------------  ▌
ECHO     ▐                                                            ▌
ECHO     ▐          Do you want to proceed with the operations?       ▌
ECHO     ▐                                                            ▌
ECHO     ▐                [Y] Yes - Start Overhaul                    ▌
ECHO     ▐                [N] No  - Exit Script                       ▌
ECHO     ▐                                                            ▌
ECHO     ▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌
ECHO.
CHOICE /C YN /M "          Your choice: "
IF ERRORLEVEL 2 GOTO EndScript
IF ERRORLEVEL 1 GOTO MainExecution


:: =============================================================================
:: Main Execution Flow
:: =============================================================================
:MainExecution
mode 120,40
CLS
ECHO.
ECHO  Starting Mad System Sweeper Overhaul...
ECHO  Configuration loaded. Stand by.
ECHO.
TIMEOUT /T 2 /NOBREAK >nul

IF "%RUN_PHASE_1_CORE_OPS%"=="TRUE" CALL :Phase1_CoreSystemOperations
IF "%RUN_PHASE_2_FILE_CLEANUP%"=="TRUE" CALL :Phase2_FileFolderCleanup
IF "%RUN_PHASE_3_MAINTENANCE%"=="TRUE" CALL :Phase3_SystemMaintenance
IF "%RUN_PHASE_4_APP_DATA%"=="TRUE" CALL :Phase4_AppDataAndPolicy

CALL :Log.Header "Mad System Sweeper - Overhaul Complete"
ECHO.
ECHO  It is STRONGLY RECOMMENDED to RESTART your computer now to apply all
ECHO  pending changes (e.g., chkdsk, component cleanup).
ECHO.
PAUSE
GOTO :EOF


:: #############################################################################
:: # PHASE 1: CORE SYSTEM OPERATIONS
:: #############################################################################
:Phase1_CoreSystemOperations
CALL :Log.Header "PHASE 1: Core System Operations"
CALL :Module_SystemStateConfig
CALL :Module_ProcessServiceManagement
GOTO :EOF

:Module_SystemStateConfig
CALL :Log.SubHeader "Module: System State and Configuration"
ECHO  [..] Disabling Reserved Storage (approx. 7GB)...
Dism /Online /Set-ReservedStorageState /State:Disabled /Quiet /NoRestart
IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "Disabled") ELSE (CALL :Log.Failure "Failed - Code: !ERRORLEVEL!")

ECHO  [..] Deleting USN Journal for C: drive...
fsutil usn deletejournal /d /n c: >nul
IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "Journal deleted") ELSE (CALL :Log.Failure "Failed - Code: !ERRORLEVEL!")

ECHO  [..] Scheduling CHKDSK for C: on next reboot...
chkdsk /scan c: >nul
CALL :Log.Info "Scheduled. Scan will run on the next restart."

ECHO  [..] Flushing DNS Cache...
ipconfig /flushdns >nul
IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "Flushed") ELSE (CALL :Log.Failure "Failed - Code: !ERRORLEVEL!")

ECHO  [..] Updating Winget sources...
IF EXIST "%ProgramFiles%\WindowsApps\*Microsoft.DesktopAppInstaller*_winget.exe" (
    winget source update >nul
    IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "Updated") ELSE (CALL :Log.Warning "Update command ran with code: !ERRORLEVEL!")
) ELSE (
    CALL :Log.Warning "Winget not found, skipping."
)
GOTO :EOF

:Module_ProcessServiceManagement
CALL :Log.SubHeader "Module: Process and Service Management"
ECHO  Terminating specified processes...
FOR %%P IN (%ProcessesToKill%) DO (
    ECHO    [..] Attempting to terminate %%P...
    taskkill /im %%P /f >nul 2>&1
    SET "KillResult=!ERRORLEVEL!"
    IF !KillResult! EQU 0 (
        CALL :Log.Success "Terminated %%P"
    ) ELSE (
        IF !KillResult! EQU 128 (
            CALL :Log.Info "%%P was not running."
        ) ELSE (
            CALL :Log.Failure "Could not terminate %%P (Error: !KillResult!)"
        )
    )
)

ECHO.
ECHO  Stopping specified services...
FOR %%S IN (%ServicesToStop%) DO (
    ECHO    [..] Checking service %%S...
    sc query %%S 2>NUL | find "STATE" | find "RUNNING" >nul
    IF !ERRORLEVEL! EQU 0 (
        net stop %%S /y >nul 2>&1
        IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "Stop signal sent to %%S") ELSE (CALL :Log.Failure "Failed to stop %%S")
    ) ELSE (
        CALL :Log.Info "Service %%S not running or not found."
    )
)

ECHO.
ECHO  [..] Salvaging WMI Repository...
winmgmt /salvagerepository >nul
IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "WMI repository salvaged") ELSE (CALL :Log.Failure "WMI salvage failed - Code: !ERRORLEVEL!")

ECHO  [..] Ending Wininet CacheTask scheduled task...
schtasks /End /TN "\Microsoft\Windows\Wininet\CacheTask" >nul 2>&1
IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "CacheTask ended") ELSE (CALL :Log.Warning "CacheTask not running or not found.")
GOTO :EOF


:: #############################################################################
:: # PHASE 2: FILE AND FOLDER CLEANUP
:: #############################################################################
:Phase2_FileFolderCleanup
CALL :Log.Header "PHASE 2: Aggressive File and Folder Cleanup"
CALL :Module_CriticalFileHandling
CALL :Module_RecycleBinCleanup
CALL :Module_TempAndCacheFileDeletion
GOTO :EOF

:Module_CriticalFileHandling
CALL :Log.SubHeader "Module: Critical File Handling (pending.xml)"
IF EXIST "%WINDIR%\winsxs\pending.xml" (
    ECHO  [..] Taking ownership of pending.xml...
    takeown /f "%WINDIR%\winsxs\pending.xml" /a >nul 2>&1
    IF !ERRORLEVEL! EQU 0 (
        ECHO  [..] Granting admin permissions...
        icacls "%WINDIR%\winsxs\pending.xml" /grant:r Administrators:F /c >nul 2>&1
        ECHO  [..] Deleting pending.xml...
        del "%WINDIR%\winsxs\pending.xml" /s /f /q
        IF NOT EXIST "%WINDIR%\winsxs\pending.xml" (
            CALL :Log.Success "Deleted pending.xml"
        ) ELSE (
            CALL :Log.Failure "Could not delete pending.xml after permission change."
        )
    ) ELSE (
        CALL :Log.Failure "Could not take ownership of pending.xml"
    )
) ELSE (
    CALL :Log.Info "pending.xml not found."
)
GOTO :EOF

:Module_RecycleBinCleanup
CALL :Log.SubHeader "Module: Recycle Bin Cleanup"
CALL :Log.Warning "This PERMANENTLY DELETES contents of all found Recycle Bins!"
FOR %%D IN (C D Z) DO (
    IF EXIST "%%D:\$Recycle.bin" (
        ECHO  [..] Clearing Recycle Bin on drive %%D:
        rd "%%D:\$Recycle.bin" /s /q
        IF NOT EXIST "%%D:\$Recycle.bin" (
            CALL :Log.Success "Cleared drive %%D:"
        ) ELSE (
            CALL :Log.Failure "Failed to clear drive %%D:"
        )
    )
)
GOTO :EOF

:Module_TempAndCacheFileDeletion
CALL :Log.SubHeader "Module: Temporary and Cache File Deletion"
SET "FoldersToRD="
SET "FoldersToRD=%FoldersToRD% \"%LocalAppData%\Microsoft\Windows\WebCache\""
SET "FoldersToRD=%FoldersToRD% \"%LocalAppData%\Temp\""
SET "FoldersToRD=%FoldersToRD% \"%ProgramData%\Applications\""
SET "FoldersToRD=%FoldersToRD% \"%ProgramData%\Package Cache\""
SET "FoldersToRD=%FoldersToRD% \"%ProgramData%\USOPrivate\UpdateStore\""
SET "FoldersToRD=%FoldersToRD% \"%SystemDrive%\$GetCurrent\""
SET "FoldersToRD=%FoldersToRD% \"%SystemDrive%\$SysReset\""
SET "FoldersToRD=%FoldersToRD% \"%SystemDrive%\$Windows.~BT\""
SET "FoldersToRD=%FoldersToRD% \"%SystemDrive%\$Windows.~WS\""
SET "FoldersToRD=%FoldersToRD% \"%SystemDrive%\$WinREAgent\""
SET "FoldersToRD=%FoldersToRD% \"%SystemDrive%\OneDriveTemp\""
SET "FoldersToRD=%FoldersToRD% \"%WINDIR%\Installer\$PatchCache$\""
SET "FoldersToRD=%FoldersToRD% \"%WINDIR%\SoftwareDistribution\Download\""
SET "FoldersToRD=%FoldersToRD% \"%WINDIR%\Temp\""
SET "FoldersToRD=%FoldersToRD% \"%WINDIR%\WinSxS\Backup\""

ECHO  Removing temporary folders...
FOR %%F IN (%FoldersToRD%) DO (
    ECHO    [..] Processing %%~F
    IF EXIST %%~F (
        rd %%~F /s /q
        IF NOT EXIST %%~F (
            CALL :Log.Success "Removed"
        ) ELSE (
            CALL :Log.Warning "Could not remove. Likely in use."
        )
    ) ELSE (
        CALL :Log.Info "Not found."
    )
)

SET "FilesToDEL="
SET "FilesToDEL=%FilesToDEL% \"%ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr*.dat\""
SET "FilesToDEL=%FilesToDEL% \"%ProgramData%\USOShared\Logs\*.*\""
SET "FilesToDEL=%FilesToDEL% \"%WINDIR%\Logs\*.*\""
SET "FilesToDEL=%FilesToDEL% \"%WINDIR%\System32\LogFiles\*.*\""
SET "FilesToDEL=%FilesToDEL% \"%WINDIR%\System32\winevt\Logs\*.*\""
SET "FilesToDEL=%FilesToDEL% \"%temp%\*.*\""

ECHO.
ECHO  Deleting temporary log and cache files...
FOR %%X IN (%FilesToDEL%) DO (
    ECHO    [..] Deleting files matching %%~X
    del %%~X /s /f /q >nul 2>&1
    CALL :Log.Info "Cleanup attempted."
)
GOTO :EOF


:: #############################################################################
:: # PHASE 3: SYSTEM MAINTENANCE AND OPTIMIZATION
:: #############################################################################
:Phase3_SystemMaintenance
CALL :Log.Header "PHASE 3: System Maintenance and Optimization"
CALL :Module_VSSManagement
CALL :Module_WinSxSConfig
CALL :Module_DISMOperations
CALL :Module_DiskCleanupConfig
CALL :Module_AutomatedDiskCleanup
GOTO :EOF

:Module_VSSManagement
CALL :Log.SubHeader "Module: Volume Shadow Copy (System Restore) Management"
CALL :Log.Warning "This will delete ALL system restore points for drive C:"
ECHO  [..] Deleting shadow copies for C: drive...
vssadmin delete shadows /for=c: /all /quiet
IF !ERRORLEVEL! EQU 0 (
    CALL :Log.Success "Shadow copies deleted"
) ELSE (
    CALL :Log.Failure "Failed or no copies exist. Code: !ERRORLEVEL!"
)
GOTO :EOF

:Module_WinSxSConfig
CALL :Log.SubHeader "Module: WinSxS Registry Optimizations"
ECHO  [..] Applying WinSxS configurations for reduced bloat...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "CBSLogCompress" /t REG_DWORD /d "1" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableComponentBackups" /t REG_DWORD /d "1" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableResetbase" /t REG_DWORD /d "1" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "NumCBSPersistLogs" /t REG_DWORD /d "0" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "SupersededActions" /t REG_DWORD /d "3" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "TransientManifestCache" /t REG_DWORD /d "1" /f >nul
CALL :Log.Success "WinSxS configs applied."
GOTO :EOF

:Module_DISMOperations
CALL :Log.SubHeader "Module: DISM Component Store Cleanup"
ECHO  [..] Getting mounted WIM info...
Dism /get-mountedwiminfo >nul
CALL :Log.Info "Mounted images checked."

ECHO  [..] Cleaning up any orphaned mount points...
Dism /cleanup-mountpoints >nul
CALL :Log.Success "Mount points cleaned."

ECHO  [..] Cleaning up WIM resources...
Dism /cleanup-wim >nul
CALL :Log.Success "WIM resources cleaned."

ECHO  [..] Starting Component Cleanup (this may take several minutes)...
Dism /Online /Cleanup-Image /StartComponentCleanup >nul
IF !ERRORLEVEL! EQU 0 (
    CALL :Log.Success "Component cleanup initiated"
) ELSE (
    CALL :Log.Failure "DISM failed - Code: !ERRORLEVEL!"
)
CALL :Log.Info "A restart is often required to finalize DISM cleanup."
GOTO :EOF

:Module_DiskCleanupConfig
CALL :Log.SubHeader "Module: Disk Cleanup Registry Configuration"
ECHO  [..] Configuring cleanmgr settings via registry...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Content Indexer Cleaner" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\D3D Shader Cache" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Delivery Optimization Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Device Driver Packages" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Diagnostic Data Viewer database files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\DownloadsFolder" /v "StateFlags6553" /t REG_DWORD /d "0" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Offline Pages Files" /v "StateFlags6553" /t REG_DWORD /d "0" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v "StateFlags6553" /t REG_DWORD /d "0" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows ESD installation files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files" /v "StateFlags6553" /t REG_DWORD /d "2" /f >nul
CALL :Log.Success "Cleanmgr pre-configured with advanced settings."
GOTO :EOF

:Module_AutomatedDiskCleanup
CALL :Log.SubHeader "Module: Automated Disk Cleanup (cleanmgr)"
ECHO  [..] Running Disk Cleanup with automated settings...
cleanmgr /sagerun:6553
CALL :Log.Info "Cleanmgr process launched. It will run in the background."
GOTO :EOF


:: #############################################################################
:: # PHASE 4: APPLICATION DATA MANAGEMENT AND POLICY
:: #############################################################################
:Phase4_AppDataAndPolicy
CALL :Log.Header "PHASE 4: Application Data Management"
CALL :Module_ApplicationDataBackup
CALL :Module_SystemPolicyModification
GOTO :EOF

:Module_ApplicationDataBackup
CALL :Log.SubHeader "Module: Application Data Backup/Sync"
IF NOT EXIST "%AppDataBackupDestBase%\" (
    CALL :Log.Failure "Backup destination not found: %AppDataBackupDestBase%"
    CALL :Log.Info "Skipping application data backup."
    GOTO :EOF
)

ECHO  [..] Terminating browser processes before backup...
FOR %%P IN (%BrowsersToKill%) DO (
    taskkill /im %%P /f >nul 2>&1
)
CALL :Log.Info "Browser termination signals sent."

ECHO.
ECHO  Backing up Browser Profiles from %AppDataSourceDrive% to %AppDataBackupDestBase%...
FOR %%B IN (%BrowsersToBackup%) DO (
    ECHO    [..] Processing %%B profile...
    IF EXIST "%AppDataSourceDrive%\%%B" (
        IF EXIST "%AppDataBackupDestBase%\%%B" ( rd "%AppDataBackupDestBase%\%%B" /s /q )
        xcopy "%AppDataSourceDrive%\%%B" "%AppDataBackupDestBase%\%%B\" /s /i /e /y /q >nul
        IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "%%B profile backed up.") ELSE (CALL :Log.Failure "%%B backup failed - Code: !ERRORLEVEL!")
    ) ELSE (
        CALL :Log.Warning "Source for %%B not found at %AppDataSourceDrive%\%%B"
    )
)

ECHO.
ECHO  Backing up Application Settings to %AppSettingsBackupDestBase%...
FOR %%A IN (%AppSettingsToBackup%) DO (
    ECHO    [..] Processing %%A settings...
    SET "SrcPath=%AppData%\%%A"
    IF "%%A"=="PotPlayerMini64" SET "SrcFile=%AppData%\PotPlayerMini64\PotPlayerMini64.ini"
    IF "%%A"=="SystemInformer" SET "SrcFile=%AppData%\SystemInformer\settings.xml"
    IF "%%A"=="Wise Disk Cleaner" SET "SrcFile=%AppData%\Wise Disk Cleaner\Config.ini"
    IF "%%A"=="Wise Registry Cleaner" SET "SrcFile=%AppData%\Wise Registry Cleaner\Config.ini"
    IF EXIST "!SrcFile!" (
        IF NOT EXIST "%AppSettingsBackupDestBase%\%%A\" MKDIR "%AppSettingsBackupDestBase%\%%A\" >nul 2>&1
        xcopy "!SrcFile!" "%AppSettingsBackupDestBase%\%%A\!SrcFile:~!SrcFile:~-!SrcFile:\= !!" /y /q >nul
        IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "%%A settings backed up.") ELSE (CALL :Log.Failure "%%A backup failed - Code: !ERRORLEVEL!")
    ) ELSE (
        CALL :Log.Warning "Source for %%A not found: !SrcFile!"
    )
)
GOTO :EOF

:Module_SystemPolicyModification
CALL :Log.SubHeader "Module: System Policy Modification"
CALL :Log.Warning "This next change can have security implications."
ECHO  [..] Disabling 'ValidateAdminCodeSignatures' policy...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ValidateAdminCodeSignatures" /t REG_DWORD /d "0" /f >nul
IF !ERRORLEVEL! EQU 0 (CALL :Log.Success "Policy set successfully.") ELSE (CALL :Log.Failure "Failed to set policy - Code: !ERRORLEVEL!")
GOTO :EOF


:: #############################################################################
:: # UTILITY SUBROUTINES
:: #############################################################################

:Log.Header
ECHO.
ECHO  =========================================================================
ECHO   %~1
ECHO  =========================================================================
ECHO.
GOTO :EOF

:Log.SubHeader
ECHO.
ECHO  --- %~1 ---
GOTO :EOF

:Log.Success
ECHO      [OK] %~1
GOTO :EOF

:Log.Failure
ECHO      [FAIL] %~1
GOTO :EOF

:Log.Warning
ECHO      [WARN] %~1
GOTO :EOF

:Log.Info
ECHO      [INFO] %~1
GOTO :EOF


:: #############################################################################
:: # SCRIPT EXIT POINTS
:: #############################################################################

:EndScript
CLS
ECHO.
ECHO  User chose to cancel. No operations were performed.
ECHO.
PAUSE
:EOF