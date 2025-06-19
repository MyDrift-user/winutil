function Register-ButtonHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for all UI buttons and controls
    
    .PARAMETER Window
    The WPF window object (deprecated - use Sync instead)
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER PresetsConfig
    The presets configuration object
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$PresetsConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        Write-Log "Registering UI event handlers..." -Level "DEBUG"
        
        # Get log TextBox for UI updates
        if ($Sync) {
            $txtLog = Get-UIControl -Sync $Sync -ControlName "txtLog"
            
            # Register all handlers
            Register-SearchHandlers -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -LogTextBox $txtLog -Sync $Sync
            Register-PresetHandlers -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -LogTextBox $txtLog -Sync $Sync
            Register-ActionHandlers -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -LogTextBox $txtLog -Sync $Sync
            Register-GeneralHandlers -LogTextBox $txtLog -Sync $Sync
        } else {
            # Fallback to old method
            $txtLog = $Window.FindName("txtLog")
            
            Register-SearchHandlers -Window $Window -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -LogTextBox $txtLog
            Register-PresetHandlers -Window $Window -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -LogTextBox $txtLog
            Register-ActionHandlers -Window $Window -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -LogTextBox $txtLog
            Register-GeneralHandlers -Window $Window -LogTextBox $txtLog
        }
        
        Write-Log "Event handlers registered successfully" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception registering event handlers: $($_.Exception.Message)" -Level "ERROR"
        throw
    }
}

function Register-SearchHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for search functionality
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$true)]
        [System.Windows.Controls.TextBox]$LogTextBox,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get search control
        if ($Sync) {
            $txtSearch = Get-UIControl -Sync $Sync -ControlName "txtSearch"
        } else {
            $txtSearch = $Window.FindName("txtSearch")
        }
        
        if ($txtSearch) {
            $txtSearch.Add_TextChanged({
                $searchText = $this.Text
                if ($Sync) {
                    Filter-Content -Sync $Sync -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -SearchText $searchText
                } else {
                    # Fallback for old method - simplified
                    Write-Log "Search functionality requires Sync hashtable" -Level "WARN" -UITextBox $LogTextBox
                }
            })
        }
    }
    catch {
        Write-Log "Exception registering search handlers: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Register-PresetHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for preset buttons
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$PresetsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$true)]
        [System.Windows.Controls.TextBox]$LogTextBox,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get preset buttons
        if ($Sync) {
            $btnPresetStandard = Get-UIControl -Sync $Sync -ControlName "btnPresetStandard"
            $btnPresetMinimal = Get-UIControl -Sync $Sync -ControlName "btnPresetMinimal"
            $btnClearSelection = Get-UIControl -Sync $Sync -ControlName "btnClearSelection"
        } else {
            $btnPresetStandard = $Window.FindName("btnPresetStandard")
            $btnPresetMinimal = $Window.FindName("btnPresetMinimal")
            $btnClearSelection = $Window.FindName("btnClearSelection")
        }
        
        # Standard Setup Preset
        if ($btnPresetStandard) {
            $btnPresetStandard.Add_Click({
                try {
                    Write-Log "Applying Standard Setup preset..." -Level "INFO" -UITextBox $LogTextBox
                    Apply-Preset -PresetName "standard" -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync -Window $Window
                }
                catch {
                    Write-Log "Exception applying Standard preset: $($_.Exception.Message)" -Level "ERROR" -UITextBox $LogTextBox
                }
            })
        }
        
        # Minimal Setup Preset
        if ($btnPresetMinimal) {
            $btnPresetMinimal.Add_Click({
                try {
                    Write-Log "Applying Minimal Setup preset..." -Level "INFO" -UITextBox $LogTextBox
                    Apply-Preset -PresetName "minimal" -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync -Window $Window
                }
                catch {
                    Write-Log "Exception applying Minimal preset: $($_.Exception.Message)" -Level "ERROR" -UITextBox $LogTextBox
                }
            })
        }
        
        # Clear All Selection
        if ($btnClearSelection) {
            $btnClearSelection.Add_Click({
                try {
                    Write-Log "Clearing all selections..." -Level "INFO" -UITextBox $LogTextBox
                    Clear-AllSelections -Sync $Sync -Window $Window
                }
                catch {
                    Write-Log "Exception clearing selections: $($_.Exception.Message)" -Level "ERROR" -UITextBox $LogTextBox
                }
            })
        }
    }
    catch {
        Write-Log "Exception registering preset handlers: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Register-ActionHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for action buttons (install, uninstall, apply, undo)
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$true)]
        [System.Windows.Controls.TextBox]$LogTextBox,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get action buttons
        if ($Sync) {
            $btnInstallApps = Get-UIControl -Sync $Sync -ControlName "btnInstallApps"
            $btnUninstallApps = Get-UIControl -Sync $Sync -ControlName "btnUninstallApps"
            $btnApplyTweaks = Get-UIControl -Sync $Sync -ControlName "btnApplyTweaks"
            $btnUndoTweaks = Get-UIControl -Sync $Sync -ControlName "btnUndoTweaks"
        } else {
            $btnInstallApps = $Window.FindName("btnInstallApps")
            $btnUninstallApps = $Window.FindName("btnUninstallApps")
            $btnApplyTweaks = $Window.FindName("btnApplyTweaks")
            $btnUndoTweaks = $Window.FindName("btnUndoTweaks")
        }
        
        # Install Selected Apps
        if ($btnInstallApps) {
            $btnInstallApps.Add_Click({
                try {
                    $selectedApps = Get-SelectedApplications -Sync $Sync -Window $Window
                    if ($selectedApps.Count -eq 0) {
                        Write-Log "No applications selected for installation" -Level "WARN" -UITextBox $LogTextBox
                        return
                    }
                    
                    Write-Log "Starting installation of $($selectedApps.Count) applications..." -Level "INFO" -UITextBox $LogTextBox
                    
                    # Disable UI during operation
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    # Install apps in parallel using runspaces
                    $runspaces = @()
                    foreach ($app in $selectedApps) {
                        $scriptBlock = {
                            param($AppID, $Config)
                            return Invoke-WinutilAppAction -AppID $AppID -Action "Install" -Config $Config
                        }
                        
                        $runspaceInfo = Start-Runspace -ScriptBlock $scriptBlock -Parameters @{
                            AppID = $app.ID
                            Config = $AppsConfig
                        } -Name "Install_$($app.ID)"
                        
                        if ($runspaceInfo) {
                            $runspaces += $runspaceInfo
                        }
                    }
                    
                    # Wait for completion and update UI
                    $successful = 0
                    $failed = 0
                    foreach ($runspaceInfo in $runspaces) {
                        $result = Wait-Runspace -RunspaceInfo $runspaceInfo
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Installation completed. Success: $successful, Failed: $failed" -Level "INFO" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception during app installation: $($_.Exception.Message)" -Level "ERROR" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
            })
        }
        
        # Uninstall Selected Apps
        if ($btnUninstallApps) {
            $btnUninstallApps.Add_Click({
                try {
                    $selectedApps = Get-SelectedApplications -Sync $Sync -Window $Window
                    if ($selectedApps.Count -eq 0) {
                        Write-Log "No applications selected for uninstallation" -Level "WARN" -UITextBox $LogTextBox
                        return
                    }
                    
                    Write-Log "Starting uninstallation of $($selectedApps.Count) applications..." -Level "INFO" -UITextBox $LogTextBox
                    
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    $runspaces = @()
                    foreach ($app in $selectedApps) {
                        $scriptBlock = {
                            param($AppID, $Config)
                            return Invoke-WinutilAppAction -AppID $AppID -Action "Uninstall" -Config $Config
                        }
                        
                        $runspaceInfo = Start-Runspace -ScriptBlock $scriptBlock -Parameters @{
                            AppID = $app.ID
                            Config = $AppsConfig
                        } -Name "Uninstall_$($app.ID)"
                        
                        if ($runspaceInfo) {
                            $runspaces += $runspaceInfo
                        }
                    }
                    
                    $successful = 0
                    $failed = 0
                    foreach ($runspaceInfo in $runspaces) {
                        $result = Wait-Runspace -RunspaceInfo $runspaceInfo
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Uninstallation completed. Success: $successful, Failed: $failed" -Level "INFO" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception during app uninstallation: $($_.Exception.Message)" -Level "ERROR" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
            })
        }
        
        # Apply Selected Tweaks
        if ($btnApplyTweaks) {
            $btnApplyTweaks.Add_Click({
                try {
                    $selectedTweaks = Get-SelectedTweaks -Sync $Sync -Window $Window
                    if ($selectedTweaks.Count -eq 0) {
                        Write-Log "No tweaks selected for application" -Level "WARN" -UITextBox $LogTextBox
                        return
                    }
                    
                    Write-Log "Applying $($selectedTweaks.Count) tweaks..." -Level "INFO" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    $successful = 0
                    $failed = 0
                    
                    # Apply tweaks sequentially to avoid conflicts
                    foreach ($tweakID in $selectedTweaks) {
                        $result = Invoke-WinutilTweakAction -TweakID $tweakID -Action "Apply" -Config $TweaksConfig
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Tweaks application completed. Success: $successful, Failed: $failed" -Level "INFO" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception applying tweaks: $($_.Exception.Message)" -Level "ERROR" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
            })
        }
        
        # Undo Selected Tweaks
        if ($btnUndoTweaks) {
            $btnUndoTweaks.Add_Click({
                try {
                    $selectedTweaks = Get-SelectedTweaks -Sync $Sync -Window $Window
                    if ($selectedTweaks.Count -eq 0) {
                        Write-Log "No tweaks selected for undo" -Level "WARN" -UITextBox $LogTextBox
                        return
                    }
                    
                    Write-Log "Undoing $($selectedTweaks.Count) tweaks..." -Level "INFO" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    $successful = 0
                    $failed = 0
                    
                    foreach ($tweakID in $selectedTweaks) {
                        $result = Invoke-WinutilTweakAction -TweakID $tweakID -Action "Undo" -Config $TweaksConfig
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Tweaks undo completed. Success: $successful, Failed: $failed" -Level "INFO" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception undoing tweaks: $($_.Exception.Message)" -Level "ERROR" -UITextBox $LogTextBox
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
            })
        }
    }
    catch {
        Write-Log "Exception registering action handlers: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Register-GeneralHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for general UI controls
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [System.Windows.Controls.TextBox]$LogTextBox,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get general buttons
        if ($Sync) {
            $btnCreateRestorePoint = Get-UIControl -Sync $Sync -ControlName "btnCreateRestorePoint"
            $btnClearLog = Get-UIControl -Sync $Sync -ControlName "btnClearLog"
        } else {
            $btnCreateRestorePoint = $Window.FindName("btnCreateRestorePoint")
            $btnClearLog = $Window.FindName("btnClearLog")
        }
        
        # Create Restore Point
        if ($btnCreateRestorePoint) {
            $btnCreateRestorePoint.Add_Click({
                try {
                    Write-Log "Creating system restore point..." -Level "INFO" -UITextBox $LogTextBox
                    
                    $result = Checkpoint-Computer -Description "WinUtil - Before Changes" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
                    if ($result) {
                        Write-Log "System restore point created successfully" -Level "INFO" -UITextBox $LogTextBox
                    } else {
                        Write-Log "Failed to create system restore point" -Level "WARN" -UITextBox $LogTextBox
                    }
                }
                catch {
                    Write-Log "Exception creating restore point: $($_.Exception.Message)" -Level "ERROR" -UITextBox $LogTextBox
                }
            })
        }
        
        # Clear Log
        if ($btnClearLog) {
            $btnClearLog.Add_Click({
                try {
                    $LogTextBox.Clear()
                    # Log cleared - no message needed
                }
                catch {
                    Write-Log "Exception clearing log: $($_.Exception.Message)" -Level "ERROR" -UITextBox $LogTextBox
                }
            })
        }
    }
    catch {
        Write-Log "Exception registering general handlers: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Apply-Preset {
    <#
    .SYNOPSIS
    Applies a preset by selecting the appropriate apps and tweaks
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$PresetName,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$PresetsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        # First clear all selections
        Clear-AllSelections -Sync $Sync -Window $Window
        
        # Check if preset exists
        if (-not $PresetsConfig.PSObject.Properties[$PresetName]) {
            Write-Log "Preset '$PresetName' not found" -Level "ERROR"
            return
        }
        
        $preset = $PresetsConfig.PSObject.Properties[$PresetName].Value
        
        # Select applications if specified
        if ($preset.applications -and $preset.applications.Count -gt 0) {
            Select-Applications -AppIDs $preset.applications -Sync $Sync -Window $Window
                                Write-Log "Selected $($preset.applications.Count) applications from preset" -Level "DEBUG"
        }
        
        # Select tweaks if specified
        if ($preset.tweaks -and $preset.tweaks.Count -gt 0) {
            Select-Tweaks -TweakIDs $preset.tweaks -Sync $Sync -Window $Window
                                Write-Log "Selected $($preset.tweaks.Count) tweaks from preset" -Level "DEBUG"
        }
        
        Write-Log "Preset '$PresetName' applied successfully" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception applying preset '$PresetName': $($_.Exception.Message)" -Level "ERROR"
    }
}

function Clear-AllSelections {
    <#
    .SYNOPSIS
    Clears all selections in both applications and tweaks
    #>
    param(
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        # Clear application selections
        if ($Sync) {
            $lstApplications = Get-UIControl -Sync $Sync -ControlName "lstApplications"
        } else {
            $lstApplications = $Window.FindName("lstApplications")
        }
        
        if ($lstApplications) {
            foreach ($item in $lstApplications.Items) {
                $container = $lstApplications.ItemContainerGenerator.ContainerFromItem($item)
                if ($container) {
                    $checkBox = Find-VisualChild -Parent $container -Type ([System.Windows.Controls.CheckBox])
                    if ($checkBox) {
                        $checkBox.IsChecked = $false
                    }
                }
            }
        }
        
        # Clear tweak selections
        if ($Sync) {
            $trvTweaks = Get-UIControl -Sync $Sync -ControlName "trvTweaks"
        } else {
            $trvTweaks = $Window.FindName("trvTweaks")
        }
        
        if ($trvTweaks) {
            foreach ($categoryNode in $trvTweaks.Items) {
                foreach ($tweakNode in $categoryNode.Items) {
                    $stackPanel = $tweakNode.Header
                    if ($stackPanel -is [System.Windows.Controls.StackPanel]) {
                        $checkBox = $stackPanel.Children | Where-Object { $_ -is [System.Windows.Controls.CheckBox] } | Select-Object -First 1
                        if ($checkBox) {
                            $checkBox.IsChecked = $false
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Log "Exception clearing selections: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Select-Applications {
    <#
    .SYNOPSIS
    Selects applications by their IDs
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$AppIDs,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        if ($Sync) {
            $lstApplications = Get-UIControl -Sync $Sync -ControlName "lstApplications"
        } else {
            $lstApplications = $Window.FindName("lstApplications")
        }
        
        if ($lstApplications) {
            foreach ($item in $lstApplications.Items) {
                if ($AppIDs -contains $item.ID) {
                    $container = $lstApplications.ItemContainerGenerator.ContainerFromItem($item)
                    if ($container) {
                        $checkBox = Find-VisualChild -Parent $container -Type ([System.Windows.Controls.CheckBox])
                        if ($checkBox) {
                            $checkBox.IsChecked = $true
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Log "Exception selecting applications: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Select-Tweaks {
    <#
    .SYNOPSIS
    Selects tweaks by their IDs
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$TweakIDs,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        if ($Sync) {
            $trvTweaks = Get-UIControl -Sync $Sync -ControlName "trvTweaks"
        } else {
            $trvTweaks = $Window.FindName("trvTweaks")
        }
        
        if ($trvTweaks) {
            foreach ($categoryNode in $trvTweaks.Items) {
                foreach ($tweakNode in $categoryNode.Items) {
                    $stackPanel = $tweakNode.Header
                    if ($stackPanel -is [System.Windows.Controls.StackPanel]) {
                        $checkBox = $stackPanel.Children | Where-Object { $_ -is [System.Windows.Controls.CheckBox] } | Select-Object -First 1
                        if ($checkBox -and $TweakIDs -contains $checkBox.Tag) {
                            $checkBox.IsChecked = $true
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Log "Exception selecting tweaks: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Find-VisualChild {
    <#
    .SYNOPSIS
    Helper function to find visual children of a specific type
    #>
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.DependencyObject]$Parent,
        
        [Parameter(Mandatory=$true)]
        [Type]$Type
    )
    
    $childrenCount = [System.Windows.Media.VisualTreeHelper]::GetChildrenCount($Parent)
    
    for ($i = 0; $i -lt $childrenCount; $i++) {
        $child = [System.Windows.Media.VisualTreeHelper]::GetChild($Parent, $i)
        
        if ($child -is $Type) {
            return $child
        }
        
        $foundChild = Find-VisualChild -Parent $child -Type $Type
        if ($foundChild) {
            return $foundChild
        }
    }
    
    return $null
}

# Functions exported: Register-ButtonHandlers, Get-SelectedApplications, Get-SelectedTweaks, Set-UIEnabled 