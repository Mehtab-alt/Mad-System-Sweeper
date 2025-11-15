# Mad System Sweeper

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

A modular, command-line control panel for advanced Windows system maintenance and cleanup.

---

## 🚨 VERY IMPORTANT: READ BEFORE USE 🚨

> **This is a powerful and potentially destructive tool designed for system administrators and power users.** It performs aggressive cleaning operations, **deletes all system backups (Restore Points)**, modifies system policies, and permanently removes files.
>
> *   **USE ENTIRELY AT YOUR OWN RISK.**
> *   **ALWAYS BACKUP CRITICAL DATA** before running this script.
> *   **REVIEW THE CONFIGURATION** in the script file before every execution to ensure you are only running the phases you need.
> *   You are solely responsible for any actions performed by this script on your system.

## Core Philosophy: The Digital Dry Dock

This script is designed to be a "digital dry dock" for your PC. It provides a structured facility to stop non-essential services, terminate interfering processes, and perform deep maintenance that is difficult or impossible while the system is in its normal "wet" operational state. The key is its modularity—**you are the foreman who decides which operations to run.**

## Features

The script is broken down into four distinct, configurable phases. Are you ready to see what's under the hood?

*   **Phase 1: Core System Operations:** Prepares the system for maintenance by terminating key processes (Windows Update, Installers), stopping related services, flushing DNS, and salvaging the WMI repository.
*   **Phase 2: Aggressive File & Folder Cleanup:** Permanently deletes the contents of all Recycle Bins, removes a wide range of temporary files, log files, and cache folders from system locations.
*   **Phase 3: System Maintenance & Optimization:** Deletes all Volume Shadow Copies (System Restore points), applies registry tweaks to reduce WinSxS bloat, and runs a full DISM component cleanup and an automated `cleanmgr` task.
*   **Phase 4: Application Data Management:** Provides a framework for backing up application data and includes a policy modification to disable `ValidateAdminCodeSignatures`. **Warning: This change has security implications and should be understood before use.**

## How to Use

1.  **Download:** Clone this repository or download the `MadSystemSweeper.bat` file directly to your computer.
2.  **Configure:** **This is the most important step.** Open `MadSystemSweeper.bat` in a text editor (like Notepad++ or VS Code). Navigate to the `>> CONFIGURATION HUB <<` section at the top.
    *   Set the `RUN_PHASE_` switches to `TRUE` for the phases you want to perform, and `FALSE` for any you wish to skip.
    *   Carefully review and customize the lists of processes, services, and applications to perfectly match your system and requirements.
    
    > **Quick Win:** The most critical part of configuration is verifying and updating all backup paths in the `Application Data Backup Configuration` section to match your system. **Do this first!**

3.  **Execute:** Right-click the `MadSystemSweeper.bat` file and select **"Run as administrator"**. The script requires elevated privileges to perform its tasks and will not run without them.
4.  **Follow Prompts:** The script will present a final warning and a menu. Read the information carefully and press the corresponding key to either proceed with the configured operations or safely exit.
5.  **Reboot:** After the script finishes, it is **highly recommended** to restart your computer. This allows Windows to complete pending operations like `chkdsk` and finalize the component store cleanup.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
