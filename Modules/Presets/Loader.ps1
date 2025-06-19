function Load-Presets {
    <#
    .SYNOPSIS
    Loads preset configurations from JSON file
    
    .PARAMETER PresetPath
    Path to the presets JSON file
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$PresetPath
    )
    
    try {
        Write-Log "Loading presets from: $PresetPath" -Level "DEBUG"
        
        if (-not (Test-Path $PresetPath)) {
            Write-Log "Preset file not found: $PresetPath" -Level "ERROR"
            return $null
        }
        
        # Read and parse the JSON file
        $jsonContent = Get-Content -Path $PresetPath -Raw -Encoding UTF8
        $presets = $jsonContent | ConvertFrom-Json
        
        Write-Log "Successfully loaded $($presets.PSObject.Properties.Count) presets" -Level "DEBUG"
        
        # Log available presets
        foreach ($preset in $presets.PSObject.Properties) {
            $itemCount = if ($preset.Value -is [array]) { $preset.Value.Count } else { 1 }
            Write-Log "Preset '$($preset.Name)': $itemCount items" -Level "DEBUG"
        }
        
        return $presets
    }
    catch {
        Write-Log "Failed to load presets from '$PresetPath': $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

function Get-PresetItems {
    <#
    .SYNOPSIS
    Gets the items (apps/tweaks) for a specific preset
    
    .PARAMETER Presets
    The presets object loaded from Load-Presets
    
    .PARAMETER PresetName
    Name of the preset to get items for
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$true)]
        [string]$PresetName
    )
    
    try {
        if (-not $Presets.PSObject.Properties.Name -contains $PresetName) {
            Write-Log "Preset '$PresetName' not found in configuration" -Level "ERROR"
            return @()
        }
        
        $items = $Presets.$PresetName
        Write-Log "Retrieved $($items.Count) items from preset '$PresetName'" -Level "DEBUG"
        
        return $items
    }
    catch {
        Write-Log "Failed to get items for preset '$PresetName': $($_.Exception.Message)" -Level "ERROR"
        return @()
    }
}

function Invoke-PresetApps {
    <#
    .SYNOPSIS
    Installs all apps in a preset
    
    .PARAMETER PresetName
    Name of the preset containing apps
    
    .PARAMETER Presets
    The presets configuration object
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER Action
    Action to perform: Install or Uninstall
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$PresetName,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('Install', 'Uninstall')]
        [string]$Action = 'Install'
    )
    
    try {
        Write-Log "Processing apps preset '$PresetName' with action '$Action'" -Level "DEBUG"
        
        $appIds = Get-PresetItems -Presets $Presets -PresetName $PresetName
        if ($appIds.Count -eq 0) {
            Write-Log "No apps found in preset '$PresetName'" -Level "WARN"
            return $true
        }
        
        $runspaces = @()
        $successful = 0
        $failed = 0
        
        foreach ($appId in $appIds) {
            try {
                # Validate app exists in configuration
                if (-not $AppsConfig.PSObject.Properties.Name -contains $appId) {
                    Write-Log "App ID '$appId' from preset '$PresetName' not found in apps configuration" -Level "WARN"
                    $failed++
                    continue
                }
                
                # Create scriptblock for parallel execution
                $scriptBlock = {
                    param($AppID, $Action, $Config)
                    return Invoke-WinutilAppAction -AppID $AppID -Action $Action -Config $Config
                }
                
                # Start runspace for this app
                $runspaceInfo = Start-Runspace -ScriptBlock $scriptBlock -Parameters @{
                    AppID = $appId
                    Action = $Action
                    Config = $AppsConfig
                } -Name "PresetApp_$($PresetName)_$($appId)"
                
                if ($runspaceInfo) {
                    $runspaces += $runspaceInfo
                }
            }
            catch {
                Write-Log "Failed to start runspace for app '$appId': $($_.Exception.Message)" -Level "ERROR"
                $failed++
            }
        }
        
        # Wait for all runspaces to complete
        Write-Log "Waiting for $($runspaces.Count) app operations to complete..." -Level "DEBUG"
        foreach ($runspaceInfo in $runspaces) {
            try {
                $result = Wait-Runspace -RunspaceInfo $runspaceInfo
                if ($result) {
                    $successful++
                } else {
                    $failed++
                }
            }
            catch {
                Write-Log "Error waiting for app runspace: $($_.Exception.Message)" -Level "ERROR"
                $failed++
            }
        }
        
        Write-Log "Preset '$PresetName' completed. Success: $successful, Failed: $failed" -Level "INFO"
        return $failed -eq 0
    }
    catch {
        Write-Log "Exception in Invoke-PresetApps for '$PresetName': $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

function Invoke-PresetTweaks {
    <#
    .SYNOPSIS
    Applies all tweaks in a preset
    
    .PARAMETER PresetName
    Name of the preset containing tweaks
    
    .PARAMETER Presets
    The presets configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER Action
    Action to perform: Apply or Undo
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$PresetName,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('Apply', 'Undo')]
        [string]$Action = 'Apply'
    )
    
    try {
        Write-Log "Processing tweaks preset '$PresetName' with action '$Action'" -Level "DEBUG"
        
        $tweakIds = Get-PresetItems -Presets $Presets -PresetName $PresetName
        if ($tweakIds.Count -eq 0) {
            Write-Log "No tweaks found in preset '$PresetName'" -Level "WARN"
            return $true
        }
        
        $successful = 0
        $failed = 0
        
        # Process tweaks sequentially to avoid conflicts
        foreach ($tweakId in $tweakIds) {
            try {
                # Validate tweak exists in configuration
                if (-not $TweaksConfig.PSObject.Properties.Name -contains $tweakId) {
                    Write-Log "Tweak ID '$tweakId' from preset '$PresetName' not found in tweaks configuration" -Level "WARN"
                    $failed++
                    continue
                }
                
                # Apply the tweak
                $result = Invoke-WinutilTweakAction -TweakID $tweakId -Action $Action -Config $TweaksConfig
                if ($result) {
                    $successful++
                } else {
                    $failed++
                }
            }
            catch {
                Write-Log "Failed to process tweak '$tweakId': $($_.Exception.Message)" -Level "ERROR"
                $failed++
            }
        }
        
        Write-Log "Tweaks preset '$PresetName' completed. Success: $successful, Failed: $failed" -Level "INFO"
        return $failed -eq 0
    }
    catch {
        Write-Log "Exception in Invoke-PresetTweaks for '$PresetName': $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Load-Presets, Get-PresetItems, Invoke-PresetApps, Invoke-PresetTweaks 