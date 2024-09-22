# Rust Setup Script for Windows without Visual Studio

# Run this script as Administrator

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    Exit
}

# Define variables
$msys2Path = "C:\msys64"
$msys2Shell = "$msys2Path\msys2_shell.cmd"
$username = $env:USERNAME

# Function to run commands in MSYS2 shell
function Run-MSYS2Command {
    param([string]$command)
    & $msys2Shell -defterm -no-start -here -c $command
}

# Check if MSYS2 is installed
if (-not (Test-Path $msys2Path)) {
    Write-Host "MSYS2 is not installed. Please install MSYS2 from https://www.msys2.org/ and run this script again."
    Exit
}

# Update MSYS2 and install required packages
Write-Host "Updating MSYS2 and installing required packages..."
Run-MSYS2Command "pacman -Sy && pacman -Syu --noconfirm"
Run-MSYS2Command "pacman -S --needed --noconfirm base-devel mingw-w64-x86_64-toolchain mingw-w64-x86_64-rust-src rust-analyzer mingw-w64-x86_64-rust"

# Add MSYS2 paths to system PATH
Write-Host "Adding MSYS2 paths to system PATH..."
$pathsToAdd = @(
    "$msys2Path\usr\bin",
    "$msys2Path\mingw64\bin"
)

foreach ($path in $pathsToAdd) {
    if ($env:Path -notlike "*$path*") {
        [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$path", "Machine")
        $env:Path += ";$path"
    }
}

# Set Rust-related environment variables
Write-Host "Setting Rust-related environment variables..."
[Environment]::SetEnvironmentVariable("RUST_SRC_PATH", "$msys2Path\mingw64\lib\rustlib\src\rust\library", "User")
[Environment]::SetEnvironmentVariable("CARGO_HOME", "$msys2Path\home\$username\.cargo", "User")
[Environment]::SetEnvironmentVariable("RUSTUP_HOME", "$msys2Path\home\$username\.rustup", "User")

# Create or update VS Code settings
$vscodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
$vscodeSettings = @{
    "rust-analyzer.server.extraEnv" = @{
        "RUST_SRC_PATH" = "C:\msys64\mingw64\lib\rustlib\src\rust\library"
    }
    "rust-analyzer.cargo.sysroot" = "C:\msys64\mingw64"
    "rust-analyzer.checkOnSave.command" = "check"
}

if (Test-Path $vscodeSettingsPath) {
    $existingSettings = Get-Content $vscodeSettingsPath | ConvertFrom-Json
    $mergedSettings = $existingSettings | Add-Member -NotePropertyMembers $vscodeSettings -PassThru
    $mergedSettings | ConvertTo-Json -Depth 10 | Set-Content $vscodeSettingsPath
} else {
    New-Item -Path $vscodeSettingsPath -ItemType File -Force
    $vscodeSettings | ConvertTo-Json -Depth 10 | Set-Content $vscodeSettingsPath
}

Write-Host "Rust setup complete! Please restart your computer for all changes to take effect."
Write-Host "After restarting, open VS Code and install the 'rust-analyzer' extension if you haven't already."
