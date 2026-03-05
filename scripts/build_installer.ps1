# TransBook Build & Package Script
# Usage: .\scripts\build_installer.ps1
# Prerequisites: Flutter SDK, Inno Setup 6 installed

param(
    [string]$Version = "1.0.0",
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  TransBook Build & Package Script"   -ForegroundColor Cyan
Write-Host "  Version: $Version"                  -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Flutter Build
if (-not $SkipBuild) {
    Write-Host "[1/3] Building Flutter Windows Release..." -ForegroundColor Yellow
    Push-Location $ProjectRoot
    flutter build windows --release
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Flutter build failed!"
        Pop-Location
        exit 1
    }
    Pop-Location
    Write-Host "[1/3] Flutter build complete." -ForegroundColor Green
} else {
    Write-Host "[1/3] Skipping Flutter build (--SkipBuild)." -ForegroundColor DarkYellow
}

# Step 2: Verify build output exists
$BuildOutput = Join-Path $ProjectRoot "build\windows\x64\runner\Release\trans_book.exe"
if (-not (Test-Path $BuildOutput)) {
    Write-Error "Build output not found at: $BuildOutput"
    exit 1
}
Write-Host "[2/3] Build output verified." -ForegroundColor Green

# Step 3: Run Inno Setup Compiler
Write-Host "[3/3] Running Inno Setup Compiler..." -ForegroundColor Yellow

$InnoSetup = @(
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles}\Inno Setup 6\ISCC.exe"
)

$ISCC = $InnoSetup | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $ISCC) {
    Write-Error "Inno Setup 6 not found. Please install from https://jrsoftware.org/isdl.php"
    exit 1
}

$ISSFile = Join-Path $ProjectRoot "installer\transbook_setup.iss"
$DistDir = Join-Path $ProjectRoot "dist"
$TempOut = "C:\Temp\TransBook_Output"

# Ensure temp output dir exists (outside project folder to avoid Defender blocking Inno Setup)
if (-not (Test-Path $TempOut)) {
    New-Item -ItemType Directory -Path $TempOut | Out-Null
}

# Ensure dist dir exists for final copy
if (-not (Test-Path $DistDir)) {
    New-Item -ItemType Directory -Path $DistDir | Out-Null
}

& $ISCC "/DMyAppVersion=$Version" $ISSFile
if ($LASTEXITCODE -ne 0) {
    Write-Error "Inno Setup compilation failed!"
    exit 1
}

# Copy installer from temp dir back to project dist\
$InstallerName = "TransBook_Setup_v${Version}.exe"
$TempExe  = Join-Path $TempOut $InstallerName
$FinalExe = Join-Path $DistDir $InstallerName

if (Test-Path $TempExe) {
    Copy-Item -Path $TempExe -Destination $FinalExe -Force
    Write-Host "Installer copied to dist\$InstallerName" -ForegroundColor DarkGray
} else {
    Write-Warning "Installer not found at $TempExe. Check C:\Temp\TransBook_Output manually."
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "  Build Complete!"                    -ForegroundColor Green
Write-Host "  Installer: dist\TransBook_Setup_v${Version}.exe" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
