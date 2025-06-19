Write-Host "Building WinUtil..." -ForegroundColor Cyan

# Paths
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootPath = Split-Path -Parent $scriptPath
$modulesPath = Join-Path $rootPath "Modules"
$configPath = Join-Path $rootPath "Config"
$outputPath = Join-Path $rootPath "winutil.ps1"

Write-Host "Output: $outputPath" -ForegroundColor Yellow

# Start building the file
$content = @'
<#
.SYNOPSIS
WinUtil - Windows Utility Tool

.DESCRIPTION
Compiled Windows utility tool for installing applications and applying tweaks

.PARAMETER LogLevel
Logging level (INFO, WARN, ERROR, DEBUG)
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('INFO', 'WARN', 'ERROR', 'DEBUG')]
    [string]$LogLevel = 'INFO'
)

# ========================================
# EMBEDDED CONFIGURATION
# ========================================

'@

# Embed configuration files
Write-Host "Embedding configuration files..." -ForegroundColor Green

$appsJson = Get-Content -Path (Join-Path $configPath "applications.json") -Raw -Encoding UTF8
$tweaksJson = Get-Content -Path (Join-Path $configPath "tweaks.json") -Raw -Encoding UTF8
$presetsJson = Get-Content -Path (Join-Path $configPath "preset.json") -Raw -Encoding UTF8

$content += @"

`$global:AppsConfig = '$($appsJson -replace "'", "''")'
`$global:TweaksConfig = '$($tweaksJson -replace "'", "''")'
`$global:PresetsConfig = '$($presetsJson -replace "'", "''")'

"@

# Embed XAML
Write-Host "Embedding XAML..." -ForegroundColor Green

$mainWindowXaml = Get-Content -Path (Join-Path $modulesPath "UI\XAML\MainWindow.xaml") -Raw -Encoding UTF8
$resourcesXaml = Get-Content -Path (Join-Path $modulesPath "UI\XAML\Resources.xaml") -Raw -Encoding UTF8

$content += @"

`$global:MainWindowXAML = @'
$mainWindowXaml
'@

`$global:ResourcesXAML = @'
$resourcesXaml
'@

"@

$content += @'

# ========================================
# EMBEDDED FUNCTIONS
# ========================================

'@

# Add modules in order
    $moduleFiles = @(
        "Logger\Core.ps1",
        "Process\Tracker.ps1", 
        "Process\Runner.ps1",
        "Applications\Install.ps1",
        "Applications\Uninstall.ps1",
        "Applications\General.ps1",
        "Tweaks\Registry.ps1",
        "Tweaks\Services.ps1",
        "Tweaks\Scripts.ps1",
        "Tweaks\General.ps1",
        "Presets\Loader.ps1",
        "Presets\Validator.ps1",
        "UI\Binding.ps1",
        "UI\Events.ps1"
    )

foreach ($moduleFile in $moduleFiles) {
    $fullPath = Join-Path $modulesPath $moduleFile
    if (Test-Path $fullPath) {
        Write-Host "Adding module: $moduleFile" -ForegroundColor Green
        
        $moduleContent = Get-Content -Path $fullPath -Raw -Encoding UTF8
        # Remove Export-ModuleMember lines
        $moduleContent = $moduleContent -replace "Export-ModuleMember[^\r\n]*", ""
        
        $content += "`n# ----------------------------------------`n"
        $content += "# MODULE: $moduleFile`n"
        $content += "# ----------------------------------------`n"
        $content += $moduleContent
        $content += "`n"
    }
}

# Add main execution logic
$content += @'

# ========================================
# MAIN EXECUTION
# ========================================

function Load-EmbeddedConfigurations {
    try {
        $configs = @{}
        $configs.Apps = $global:AppsConfig | ConvertFrom-Json
        $configs.Tweaks = $global:TweaksConfig | ConvertFrom-Json  
        $configs.Presets = $global:PresetsConfig | ConvertFrom-Json
        return $configs
    }
    catch {
        Write-Host "Error loading embedded configurations: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

function Start-WinUtilGUI {
    param($Configs)
    
    try {
        Add-Type -AssemblyName PresentationFramework
        Add-Type -AssemblyName PresentationCore
        Add-Type -AssemblyName WindowsBase
        
        # Extract just the styles from the resources XAML
        $resourcesContent = $global:ResourcesXAML
        $stylesOnly = $resourcesContent -replace '<ResourceDictionary[^>]*>', '' -replace '</ResourceDictionary>', ''
        
        # Replace the MergedDictionaries section with inline resources
        $xamlWithResources = $global:MainWindowXAML -replace '<ResourceDictionary\.MergedDictionaries>[\s\S]*?</ResourceDictionary\.MergedDictionaries>', $stylesOnly.Trim()
        
        Write-Log "Parsing XAML..." -Level "DEBUG"
        $window = [Windows.Markup.XamlReader]::Parse($xamlWithResources)
        
        if (-not $window) {
            Write-Log "Failed to create window" -Level "ERROR"
            return $false
        }
        
        Write-Log "Window created successfully" -Level "INFO"
        
        # Initialize UI control bindings
        $sync = @{}
        Initialize-UIControls -Window $window -Sync $sync -XamlContent $xamlWithResources
        
        # Populate UI and register handlers using sync hashtable
        Populate-UI -AppsConfig $Configs.Apps -TweaksConfig $Configs.Tweaks -PresetsConfig $Configs.Presets -Sync $sync
        Register-ButtonHandlers -AppsConfig $Configs.Apps -TweaksConfig $Configs.Tweaks -PresetsConfig $Configs.Presets -Sync $sync
        
        # Show window
        $window.ShowDialog() | Out-Null
        return $true
    }
    catch {
        Write-Log "Error starting GUI: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Main execution
try {
    Initialize-Logging -LogLevel $LogLevel
    
    $configs = Load-EmbeddedConfigurations
    if (-not $configs) {
        Write-Host "Failed to load configurations" -ForegroundColor Red
        exit 1
    }
    
    # Start GUI
    $success = Start-WinUtilGUI -Configs $configs
    exit $(if ($success) { 0 } else { 1 })
}
catch {
    Write-Host "Fatal error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    if (Get-Command "Stop-AllRunspaces" -ErrorAction SilentlyContinue) {
        Stop-AllRunspaces
    }
}

'@

# Write the final file
Write-Host "Writing compiled file..." -ForegroundColor Cyan
$content | Out-File -FilePath $outputPath -Encoding UTF8

$size = (Get-Item $outputPath).Length
Write-Host "Created winutil.ps1 ($([math]::Round($size/1024, 2)) KB)" -ForegroundColor Green
Write-Host "Done!" -ForegroundColor Green 