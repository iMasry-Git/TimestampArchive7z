param(
    [Parameter(Mandatory = $false, HelpMessage = "File or folder path to archive")]
    [string]$TargetPath
)

# If invoked from the Windows Explorer context menu one-liner, extract path after '#::'
if (-not $TargetPath) {
    $parts = [Environment]::CommandLine -split '#::'
    if ($parts.Count -gt 1) {
        $TargetPath = $parts[-1]
    }
}

$v = $TargetPath.Trim('"').TrimEnd('\')                     # Clean input path (e.g. C:\temp\foo)
if (-not $v -or -not (Test-Path -LiteralPath $v)) {
    Write-Error "Please provide a valid file or folder path. Usage: .\TimestampArchive7z.ps1 'C:\path\to\item'"
    exit 1
}

$od = [IO.Path]::GetDirectoryName($v)                       # Parent output directory (e.g. C:\temp)
$dn = if (Test-Path -LiteralPath $v -PathType Leaf) {       # Item name (without extension for files)
    [IO.Path]::GetFileNameWithoutExtension($v)
} else {
    [IO.Path]::GetFileName($v)
}
$ts = [DateTime]::Now.ToString('yyyy-MM-dd_hh-mm-ss-tt', [Globalization.CultureInfo]::InvariantCulture) # Timestamp (e.g. 2026-10-25_05-12-33-PM)
$fn = "archive_${dn}_${ts}.7z"                              # Archive filename (e.g. archive_foo_2026-10-25_05-12-33-PM.7z)
$cp = [IO.Path]::Combine($od, $fn)                          # Full destination archive path

# Locate 7-Zip (64-bit or 32-bit fallback)
$sz = if (Test-Path "$env:ProgramFiles\7-Zip\7z.exe") {
    "$env:ProgramFiles\7-Zip\7z.exe"
} else {
    "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
}

& $sz a "$cp" "$v"                                          # Create .7z archive safely with quoted paths
