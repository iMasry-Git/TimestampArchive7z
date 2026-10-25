# TimestampArchive7z
Adds a **Timestamp Archive (7-Zip)** context menu entry for folders in Windows Explorer. This lets you create a timestamped `.7z` archive of any folder with two clicks.

## Idea
When working on a folder, it is convenient to quickly create a timestamped backup archive before making changes. While 7-Zip provides a standard context menu, `TimestampArchive7z` automatically appends a sortable 24-hour timestamp (`archive_<FolderName>_<yyyy-MM-dd_HHmmss>.7z`) in a single click.

## Features
* **Sortable 24-Hour Timestamps:** Uses `yyyy-MM-dd_HHmmss` so multiple archives from the same day sort chronologically.
* **Native `.7z` Compression:** Creates `.7z` archives using 7-Zip (`64-bit` with automatic `32-bit` fallback).
* **Safe Path Handling:** Properly handles folder paths containing spaces, apostrophes (`'`), brackets (`[]`), dollar signs (`$`), and ampersands (`&`).
* **Clean Context Menu Integration:** Displays a friendly **Timestamp Archive (7-Zip)** label with the 7-Zip icon and runs silently without flashing an interactive PowerShell prompt.

## Prerequisites
* Windows 10 / 11
* Administrator privileges to import `Install_TimestampArchive7z.reg`
* PowerShell 5.1+
* [7-Zip](https://www.7-zip.org/) installed in `C:\Program Files\7-Zip` or `C:\Program Files (x86)\7-Zip`

## Installation
* Double-click `Install_TimestampArchive7z.reg` and confirm the Registry Editor prompt.

## Removal
* Double-click `Uninstall_TimestampArchive7z.reg` and confirm the Registry Editor prompt.

## Usage

### Via Windows Explorer Context Menu
1. Open Windows Explorer.
2. Right-click any folder (on Windows 11, click *Show more options* or hold `Shift` + right-click).
3. Click **Timestamp Archive (7-Zip)**.
4. A timestamped `.7z` archive (`archive_<FolderName>_<yyyy-MM-dd_HHmmss>.7z`) will be created in the same parent directory.

### Via PowerShell CLI
You can also run `TimestampArchive7z.ps1` directly from PowerShell:
```powershell
.\TimestampArchive7z.ps1 "C:\path\to\folder"
```

## Troubleshooting
* **Nothing happens when clicking the context menu item:**
  Ensure 7-Zip is installed at `C:\Program Files\7-Zip\7z.exe` (or `C:\Program Files (x86)\7-Zip\7z.exe`). To inspect errors interactively, temporarily replace `-NonInteractive -WindowStyle Hidden` with `-NoExit` in `Install_TimestampArchive7z.reg` and re-import it.
