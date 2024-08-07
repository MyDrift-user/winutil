<#
.NOTES
    Author         : Chris Titus @christitustech
    Runspace Author: @DeveloperDurp
    GitHub         : https://github.com/ChrisTitusTech
    Version        : #{replaceme}
#>
param (
    [switch]$Debug,
    [string]$Config,
    [switch]$Run
)

# Check if the current user is an administrator
if (-not ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    
    # Determine which PowerShell executable to use
    if (Get-Command "pwsh" -ErrorAction SilentlyContinue) {
        $shell = "pwsh.exe"
    } else {
        $shell = "powershell.exe"
    }

    # Elevate the script and exit the current non-elevated script
    $PwshArgList = @(
        "-NoLogo",                                  # Don't print PowerShell header in CLI
        "-NoProfile",                               # Don't load PowerShell profile
        "-File", $MyInvocation.MyCommand.Source,    # Script path
        $args | ForEach-Object { $_ }               # Script arguments
    ) | ForEach-Object { "`"$_`"" }

    Start-Process -FilePath $shell -ArgumentList $PwshArgList -Verb RunAs
    exit
}

# Set DebugPreference based on the -Debug switch
if ($Debug) {
    $DebugPreference = "Continue"
}

if ($Config) {
    $PARAM_CONFIG = $Config
}

$PARAM_RUN = $false
# Handle the -Run switch
if ($Run) {
    Write-Host "Running config file tasks..."
    $PARAM_RUN = $true
}

if (!(Test-Path -Path $ENV:TEMP)) {
    New-Item -ItemType Directory -Force -Path $ENV:TEMP
}

Start-Transcript $ENV:TEMP\Winutil.log -Append

# Load DLLs
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Variable to sync between runspaces
$sync = [Hashtable]::Synchronized(@{})
$sync.PSScriptRoot = $PSScriptRoot
$sync.version = "#{replaceme}"
$sync.configs = @{}
$sync.ProcessRunning = $false

# Set PowerShell window title
$Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Admin)"
clear-host
