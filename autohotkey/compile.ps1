# AutoHotkey Compiler Script
$ahkDir = "$env:LOCALAPPDATA\Programs\AutoHotkey"
$compiler = "$ahkDir\Compiler\Ahk2Exe.exe"

# Find the v1.x version directory
$v1Dir = Get-ChildItem -Path $ahkDir -Directory | Where-Object { $_.Name -like "v1*" } | Select-Object -First 1

if (-not $v1Dir) {
    Write-Error "Could not find v1.x AutoHotkey directory in $ahkDir"
    exit 1
}

$baseFile = "$($v1Dir.FullName)\AutoHotkeyU64.exe"

# Check if base file exists
if (-not (Test-Path $baseFile)) {
    Write-Error "Base file not found at: $baseFile"
    exit 1
}

# Get all .ahk files in current directory
$ahkFiles = Get-ChildItem -Path "." -Filter "*.ahk"

if ($ahkFiles.Count -eq 0) {
    Write-Host "No .ahk files found in current directory"
    exit 0
}

Write-Host "Found $($ahkFiles.Count) AHK file(s) to compile"
Write-Host "Using AutoHotkey version: $($v1Dir.Name)"

foreach ($file in $ahkFiles) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $outputFile = "$baseName.exe"
    
    Write-Host "Compiling $($file.Name) -> $outputFile"
    & $compiler /in $file.FullName /out $outputFile /base $baseFile
}

Write-Host "`nCompilation complete!"
