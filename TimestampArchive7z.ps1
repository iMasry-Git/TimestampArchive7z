param(
    [Parameter(Mandatory = $false, HelpMessage = "Folder path to archive")]
    [string]$FolderPath
)

# If invoked from the Windows Explorer context menu one-liner, extract path after '#::'
if (-not $FolderPath) {
    $parts = [Environment]::CommandLine -split '#::'
    if ($parts.Count -gt 1) {
        $FolderPath = $parts[-1]
    }
}

$v = $FolderPath.Trim('"').TrimEnd('\')                     # Clean input path (e.g. C:\temp\foo)
if (-not $v -or -not (Test-Path -LiteralPath $v)) {
    Write-Error "Please provide a valid folder path. Usage: .\TimestampArchive7z.ps1 'C:\path\to\folder'"
    exit 1
}

$od = [IO.Path]::GetDirectoryName($v)                       # Parent output directory (e.g. C:\temp)
$dn = [IO.Path]::GetFileName($v)                            # Folder name (e.g. foo)
$ts = Get-Date -Format 'yyyy-MM-dd_HHmmss'                  # 24-hour timestamp for chronological sorting
$fn = "archive_${dn}_${ts}.7z"                              # Archive filename (e.g. archive_foo_2026-10-25_164500.7z)
$cp = [IO.Path]::Combine($od, $fn)                          # Full destination archive path

# Locate 7-Zip (64-bit or 32-bit fallback)
$sz = if (Test-Path "$env:ProgramFiles\7-Zip\7z.exe") {
    "$env:ProgramFiles\7-Zip\7z.exe"
} else {
    "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
}

& $sz a "$cp" "$v"                                          # Create .7z archive safely with quoted paths

# Registry one-liner used in Install_TimestampArchive7z.reg:
# powershell.exe -NoProfile -NonInteractive -WindowStyle Hidden -Command "$v = ([Environment]::CommandLine -split '#::')[-1].Trim('\"').TrimEnd('\'); $od = [IO.Path]::GetDirectoryName($v); $dn = [IO.Path]::GetFileName($v); $ts = Get-Date -Format 'yyyy-MM-dd_HHmmss'; $cp = [IO.Path]::Combine($od, \"archive_${dn}_${ts}.7z\"); $sz = if (Test-Path \"$env:ProgramFiles\7-Zip\7z.exe\") { \"$env:ProgramFiles\7-Zip\7z.exe\" } else { \"${env:ProgramFiles(x86)}\7-Zip\7z.exe\" }; & $sz a \"$cp\" \"$v\" #::%V"
