function Test-Presets {
    <#
    .SYNOPSIS
    Validates that all app/tweak IDs in presets exist in their respective configurations
    
    .PARAMETER Presets
    The presets configuration object
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$false)]
        [PSCustomObject]$AppsConfig = $null,
        
        [Parameter(Mandatory=$false)]
        [PSCustomObject]$TweaksConfig = $null
    )
    
    try {
        Write-Log "Validating presets configuration..." -Level "DEBUG"
        
        $validationErrors = @()
        $validationWarnings = @()
        
        foreach ($presetProperty in $Presets.PSObject.Properties) {
            $presetName = $presetProperty.Name
            $presetItems = $presetProperty.Value
            
            Write-Log "Validating preset '$presetName' with $($presetItems.Count) items" -Level "DEBUG"
            
            foreach ($item in $presetItems) {
                $found = $false
                $itemType = "Unknown"
                
                # Check if it's an app
                if ($AppsConfig -and $AppsConfig.PSObject.Properties.Name -contains $item) {
                    $found = $true
                    $itemType = "App"
                }
                
                # Check if it's a tweak
                if ($TweaksConfig -and $TweaksConfig.PSObject.Properties.Name -contains $item) {
                    if ($found) {
                        # Item exists in both configs - this is a warning
                        $warning = "Item '$item' in preset '$presetName' exists in both apps and tweaks configurations"
                        $validationWarnings += $warning
                        Write-Log $warning -Level "WARN"
                    } else {
                        $found = $true
                        $itemType = "Tweak"
                    }
                }
                
                if (-not $found) {
                    $errorMessage = "Item '$item' in preset '$presetName' not found in any configuration"
                    $validationErrors += $errorMessage
                    Write-Log $errorMessage -Level "ERROR"
                } else {
                    Write-Log "Item '$item' in preset '$presetName' validated as $itemType" -Level "DEBUG"
                }
            }
        }
        
        # Summary
        $totalPresets = $Presets.PSObject.Properties.Count
        $totalItems = ($Presets.PSObject.Properties.Value | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
        
        Write-Log "Validation completed:" -Level "DEBUG"
        Write-Log "  - Total presets: $totalPresets" -Level "DEBUG"
        Write-Log "  - Total items: $totalItems" -Level "DEBUG"
        Write-Log "  - Errors: $($validationErrors.Count)" -Level "DEBUG"
        Write-Log "  - Warnings: $($validationWarnings.Count)" -Level "DEBUG"
        
        if ($validationErrors.Count -eq 0) {
            Write-Log "All presets are valid!" -Level "DEBUG"
            return @{
                IsValid = $true
                Errors = @()
                Warnings = $validationWarnings
                Summary = @{
                    TotalPresets = $totalPresets
                    TotalItems = $totalItems
                    ErrorCount = 0
                    WarningCount = $validationWarnings.Count
                }
            }
        } else {
            Write-Log "Preset validation failed with $($validationErrors.Count) errors" -Level "ERROR"
            return @{
                IsValid = $false
                Errors = $validationErrors
                Warnings = $validationWarnings
                Summary = @{
                    TotalPresets = $totalPresets
                    TotalItems = $totalItems
                    ErrorCount = $validationErrors.Count
                    WarningCount = $validationWarnings.Count
                }
            }
        }
    }
    catch {
        Write-Log "Exception during preset validation: $($_.Exception.Message)" -Level "ERROR"
        return @{
            IsValid = $false
            Errors = @("Validation exception: $($_.Exception.Message)")
            Warnings = @()
            Summary = @{
                TotalPresets = 0
                TotalItems = 0
                ErrorCount = 1
                WarningCount = 0
            }
        }
    }
}

function Get-PresetStatistics {
    <#
    .SYNOPSIS
    Gets statistics about presets configuration
    
    .PARAMETER Presets
    The presets configuration object
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$false)]
        [PSCustomObject]$AppsConfig = $null,
        
        [Parameter(Mandatory=$false)]
        [PSCustomObject]$TweaksConfig = $null
    )
    
    try {
        $stats = @{
            TotalPresets = $Presets.PSObject.Properties.Count
            PresetDetails = @{}
            ItemTypes = @{
                Apps = 0
                Tweaks = 0
                Unknown = 0
            }
            TotalItems = 0
        }
        
        foreach ($presetProperty in $Presets.PSObject.Properties) {
            $presetName = $presetProperty.Name
            $presetItems = $presetProperty.Value
            
            $presetStats = @{
                ItemCount = $presetItems.Count
                Apps = 0
                Tweaks = 0
                Unknown = 0
                Items = @()
            }
            
            foreach ($item in $presetItems) {
                $itemInfo = @{
                    ID = $item
                    Type = "Unknown"
                    Found = $false
                }
                
                # Check if it's an app
                if ($AppsConfig -and $AppsConfig.PSObject.Properties.Name -contains $item) {
                    $itemInfo.Type = "App"
                    $itemInfo.Found = $true
                    $presetStats.Apps++
                    $stats.ItemTypes.Apps++
                }
                
                # Check if it's a tweak
                if ($TweaksConfig -and $TweaksConfig.PSObject.Properties.Name -contains $item) {
                    if ($itemInfo.Found) {
                        $itemInfo.Type = "Both"  # Exists in both configs
                    } else {
                        $itemInfo.Type = "Tweak"
                        $itemInfo.Found = $true
                        $presetStats.Tweaks++
                        $stats.ItemTypes.Tweaks++
                    }
                }
                
                if (-not $itemInfo.Found) {
                    $presetStats.Unknown++
                    $stats.ItemTypes.Unknown++
                }
                
                $presetStats.Items += $itemInfo
            }
            
            $stats.PresetDetails[$presetName] = $presetStats
            $stats.TotalItems += $presetItems.Count
        }
        
        return $stats
    }
    catch {
        Write-Log "Exception getting preset statistics: $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

function Show-PresetSummary {
    <#
    .SYNOPSIS
    Displays a formatted summary of preset statistics
    
    .PARAMETER Statistics
    Statistics object from Get-PresetStatistics
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Statistics
    )
    
    try {
        Write-Log "=== PRESET SUMMARY ===" -Level "DEBUG"
        Write-Log "Total Presets: $($Statistics.TotalPresets)" -Level "DEBUG"
        Write-Log "Total Items: $($Statistics.TotalItems)" -Level "DEBUG"
        Write-Log "Apps: $($Statistics.ItemTypes.Apps)" -Level "DEBUG"
        Write-Log "Tweaks: $($Statistics.ItemTypes.Tweaks)" -Level "DEBUG"
        Write-Log "Unknown: $($Statistics.ItemTypes.Unknown)" -Level "DEBUG"
        
        Write-Log "=== PRESET DETAILS ===" -Level "DEBUG"
        foreach ($presetName in $Statistics.PresetDetails.Keys | Sort-Object) {
            $preset = $Statistics.PresetDetails[$presetName]
            Write-Log "Preset '$presetName':" -Level "DEBUG"
            Write-Log "  Total Items: $($preset.ItemCount)" -Level "DEBUG"
            Write-Log "  Apps: $($preset.Apps)" -Level "DEBUG"
            Write-Log "  Tweaks: $($preset.Tweaks)" -Level "DEBUG"
            if ($preset.Unknown -gt 0) {
                Write-Log "  Unknown: $($preset.Unknown)" -Level "WARN"
            }
        }
    }
    catch {
        Write-Log "Exception displaying preset summary: $($_.Exception.Message)" -Level "ERROR"
    }
}

# Functions exported: Test-Presets, Get-PresetStatistics, Show-PresetSummary 