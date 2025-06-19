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
        
        # Register all handlers (no log TextBox needed anymore)
        if ($Sync) {
            Register-SearchHandlers -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync
            Register-PresetHandlers -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync
            Register-ActionHandlers -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync
            Register-GeneralHandlers -Sync $Sync
        } else {
            # Fallback to old method
            Register-SearchHandlers -Window $Window -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig
            Register-PresetHandlers -Window $Window -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig
            Register-ActionHandlers -Window $Window -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig
            Register-GeneralHandlers -Window $Window
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
    Registers event handlers for unified search functionality
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get unified search control
        if ($Sync) {
            $txtSearch = Get-UIControl -Sync $Sync -ControlName "txtSearch"
            $applicationsContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
            $tweaksContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
        } else {
            $txtSearch = $Window.FindName("txtSearch")
            $applicationsContent = $Window.FindName("ApplicationsContent")
            $tweaksContent = $Window.FindName("TweaksContent")
        }
        
        # Unified search handler
        if ($txtSearch) {
            $txtSearch.Add_TextChanged({
                try {
                    $searchText = $this.Text
                    
                    # Determine which tab is active and search accordingly
                    if ($Sync) {
                        $appContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
                        $tweakContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
                        
                        if ($appContent.Visibility -eq "Visible") {
                            # Search applications
                            Filter-ApplicationContent -Sync $Sync -AppsConfig $AppsConfig -SearchText $searchText
                        } elseif ($tweakContent.Visibility -eq "Visible") {
                            # Search tweaks
                            Filter-TweakContent -Sync $Sync -TweaksConfig $TweaksConfig -SearchText $searchText
                        }
                    } else {
                        # Fallback for Window-based approach
                        $appContent = $Window.FindName("ApplicationsContent")
                        $tweakContent = $Window.FindName("TweaksContent")
                        
                        if ($appContent.Visibility -eq "Visible") {
                            Write-Log "Applications search functionality requires Sync hashtable" -Level "WARN"
                        } elseif ($tweakContent.Visibility -eq "Visible") {
                            Write-Log "Tweaks search functionality requires Sync hashtable" -Level "WARN"
                        }
                    }
                } catch {
                    Write-Log "Exception during search: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Function to update search placeholder text
        function Update-SearchPlaceholder {
            param($SearchBox, $PlaceholderText)
            
            try {
                if ($SearchBox) {
                    $SearchBox.ApplyTemplate()
                    $placeholder = $SearchBox.Template.FindName("PlaceholderText", $SearchBox)
                    if ($placeholder) {
                        $placeholder.Text = $PlaceholderText
                    }
                }
            } catch {
                Write-Log "Exception updating search placeholder: $($_.Exception.Message)" -Level "DEBUG"
            }
        }
        
        # Store reference for placeholder updates
        if ($Sync -and $txtSearch) {
            $Sync["SearchBox"] = $txtSearch
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
                    Write-Log "Applying Standard Setup preset..." -Level "INFO"
                    Apply-Preset -PresetName "standard" -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync -Window $Window
                }
                catch {
                    Write-Log "Exception applying Standard preset: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Minimal Setup Preset
        if ($btnPresetMinimal) {
            $btnPresetMinimal.Add_Click({
                try {
                    Write-Log "Applying Minimal Setup preset..." -Level "INFO"
                    Apply-Preset -PresetName "minimal" -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync -Window $Window
                }
                catch {
                    Write-Log "Exception applying Minimal preset: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Clear All Selection
        if ($btnClearSelection) {
            $btnClearSelection.Add_Click({
                try {
                    Write-Log "Clearing all selections..." -Level "INFO"
                    Clear-AllSelections -Sync $Sync -Window $Window
                }
                catch {
                    Write-Log "Exception clearing selections: $($_.Exception.Message)" -Level "ERROR"
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
                        Write-Log "No applications selected for installation" -Level "WARN"
                        return
                    }
                    
                    Write-Log "Starting installation of $($selectedApps.Count) applications..." -Level "INFO"
                    
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
                    
                    Write-Log "Installation completed. Success: $successful, Failed: $failed" -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception during app installation: $($_.Exception.Message)" -Level "ERROR"
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
                        Write-Log "No applications selected for uninstallation" -Level "WARN"
                        return
                    }
                    
                    Write-Log "Starting uninstallation of $($selectedApps.Count) applications..." -Level "INFO"
                    
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
                    
                    Write-Log "Uninstallation completed. Success: $successful, Failed: $failed" -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception during app uninstallation: $($_.Exception.Message)" -Level "ERROR"
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
                        Write-Log "No tweaks selected for application" -Level "WARN"
                        return
                    }
                    
                    Write-Log "Applying $($selectedTweaks.Count) tweaks..." -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    $successful = 0
                    $failed = 0
                    
                    # Apply tweaks sequentially to avoid conflicts
                    foreach ($tweakID in $selectedTweaks) {
                        $result = Invoke-WinutilTweakAction -TweakID $tweakID -Action "Apply" -Config $TweaksConfig
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Tweaks application completed. Success: $successful, Failed: $failed" -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception applying tweaks: $($_.Exception.Message)" -Level "ERROR"
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
                        Write-Log "No tweaks selected for undo" -Level "WARN"
                        return
                    }
                    
                    Write-Log "Undoing $($selectedTweaks.Count) tweaks..." -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    $successful = 0
                    $failed = 0
                    
                    foreach ($tweakID in $selectedTweaks) {
                        $result = Invoke-WinutilTweakAction -TweakID $tweakID -Action "Undo" -Config $TweaksConfig
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Tweaks undo completed. Success: $successful, Failed: $failed" -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception undoing tweaks: $($_.Exception.Message)" -Level "ERROR"
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
    Registers event handlers for general UI controls including tab switching
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get tab buttons and content areas
        if ($Sync) {
            $btnApplicationsTab = Get-UIControl -Sync $Sync -ControlName "btnApplicationsTab"
            $btnTweaksTab = Get-UIControl -Sync $Sync -ControlName "btnTweaksTab"
            $applicationsContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
            $tweaksContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
        } else {
            $btnApplicationsTab = $Window.FindName("btnApplicationsTab")
            $btnTweaksTab = $Window.FindName("btnTweaksTab")
            $applicationsContent = $Window.FindName("ApplicationsContent")
            $tweaksContent = $Window.FindName("TweaksContent")
        }
        
        # Tab appearance logic with improved styling (inline to avoid scoping issues)
        
        # Applications tab button click handler
        if ($btnApplicationsTab -and $applicationsContent -and $tweaksContent) {
            $btnApplicationsTab.Add_Click({
                try {
                    Write-Log "Switching to Applications tab" -Level "DEBUG"
                    
                    # Get fresh references to all controls
                    if ($Sync) {
                        $appContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
                        $tweakContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
                        $btnApps = Get-UIControl -Sync $Sync -ControlName "btnApplicationsTab"
                        $btnTweaks = Get-UIControl -Sync $Sync -ControlName "btnTweaksTab"
                    } else {
                        $appContent = $Window.FindName("ApplicationsContent")
                        $tweakContent = $Window.FindName("TweaksContent")
                        $btnApps = $Window.FindName("btnApplicationsTab")
                        $btnTweaks = $Window.FindName("btnTweaksTab")
                    }
                    
                    # Switch content visibility
                    if ($appContent) { $appContent.Visibility = "Visible" }
                    if ($tweakContent) { $tweakContent.Visibility = "Collapsed" }
                    
                    # Update tab button appearance - Applications active
                    if ($btnApps) {
                        $btnApps.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FF2D2D30")
                        $btnApps.Foreground = [System.Windows.Media.Brushes]::White
                        
                        # Show active indicator line
                        try {
                            $btnApps.ApplyTemplate()
                            $activeLine = $btnApps.Template.FindName("ActiveLine", $btnApps)
                            if ($activeLine) { $activeLine.Opacity = 1.0 }
                        } catch { }
                    }
                    if ($btnTweaks) {
                        $btnTweaks.Background = [System.Windows.Media.Brushes]::Transparent
                        $btnTweaks.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FFAAAAAA")
                        
                        # Hide active indicator line
                        try {
                            $btnTweaks.ApplyTemplate()
                            $inactiveLine = $btnTweaks.Template.FindName("ActiveLine", $btnTweaks)
                            if ($inactiveLine) { $inactiveLine.Opacity = 0.0 }
                        } catch { }
                    }
                    
                    # Update search placeholder for Applications
                    try {
                        if ($Sync -and $Sync["SearchBox"]) {
                            $searchBox = $Sync["SearchBox"]
                            $searchBox.ApplyTemplate()
                            $placeholder = $searchBox.Template.FindName("PlaceholderText", $searchBox)
                            if ($placeholder) {
                                $placeholder.Text = "Search applications..."
                            }
                        }
                    } catch { }
                }
                catch {
                    Write-Log "Exception switching to Applications tab: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Tweaks tab button click handler
        if ($btnTweaksTab -and $applicationsContent -and $tweaksContent) {
            $btnTweaksTab.Add_Click({
                try {
                    Write-Log "Switching to Tweaks tab" -Level "DEBUG"
                    
                    # Get fresh references to all controls
                    if ($Sync) {
                        $appContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
                        $tweakContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
                        $btnApps = Get-UIControl -Sync $Sync -ControlName "btnApplicationsTab"
                        $btnTweaks = Get-UIControl -Sync $Sync -ControlName "btnTweaksTab"
                    } else {
                        $appContent = $Window.FindName("ApplicationsContent")
                        $tweakContent = $Window.FindName("TweaksContent")
                        $btnApps = $Window.FindName("btnApplicationsTab")
                        $btnTweaks = $Window.FindName("btnTweaksTab")
                    }
                    
                    # Switch content visibility
                    if ($appContent) { $appContent.Visibility = "Collapsed" }
                    if ($tweakContent) { $tweakContent.Visibility = "Visible" }
                    
                    # Update tab button appearance - Tweaks active
                    if ($btnTweaks) {
                        $btnTweaks.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FF2D2D30")
                        $btnTweaks.Foreground = [System.Windows.Media.Brushes]::White
                        
                        # Show active indicator line
                        try {
                            $btnTweaks.ApplyTemplate()
                            $activeLine = $btnTweaks.Template.FindName("ActiveLine", $btnTweaks)
                            if ($activeLine) { $activeLine.Opacity = 1.0 }
                        } catch { }
                    }
                    if ($btnApps) {
                        $btnApps.Background = [System.Windows.Media.Brushes]::Transparent
                        $btnApps.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FFAAAAAA")
                        
                        # Hide active indicator line
                        try {
                            $btnApps.ApplyTemplate()
                            $inactiveLine = $btnApps.Template.FindName("ActiveLine", $btnApps)
                            if ($inactiveLine) { $inactiveLine.Opacity = 0.0 }
                        } catch { }
                    }
                    
                    # Update search placeholder for Tweaks
                    try {
                        if ($Sync -and $Sync["SearchBox"]) {
                            $searchBox = $Sync["SearchBox"]
                            $searchBox.ApplyTemplate()
                            $placeholder = $searchBox.Template.FindName("PlaceholderText", $searchBox)
                            if ($placeholder) {
                                $placeholder.Text = "Search tweaks..."
                            }
                        }
                    } catch { }
                }
                catch {
                    Write-Log "Exception switching to Tweaks tab: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Set default active tab appearance (Applications)
        try {
            if ($btnApplicationsTab) {
                $btnApplicationsTab.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FF2D2D30")
                $btnApplicationsTab.Foreground = [System.Windows.Media.Brushes]::White
            }
            if ($btnTweaksTab) {
                $btnTweaksTab.Background = [System.Windows.Media.Brushes]::Transparent
                $btnTweaksTab.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FFAAAAAA")
            }
            
            # Set default active indicator for Applications tab
            try {
                if ($btnApplicationsTab) {
                    $btnApplicationsTab.ApplyTemplate()
                    $activeLine = $btnApplicationsTab.Template.FindName("ActiveLine", $btnApplicationsTab)
                    if ($activeLine) { $activeLine.Opacity = 1.0 }
                }
                if ($btnTweaksTab) {
                    $btnTweaksTab.ApplyTemplate()
                    $inactiveLine = $btnTweaksTab.Template.FindName("ActiveLine", $btnTweaksTab)
                    if ($inactiveLine) { $inactiveLine.Opacity = 0.0 }
                }
            } catch { }
            
            # Set default search placeholder for Applications
            if ($Sync -and $Sync["SearchBox"]) {
                $searchBox = $Sync["SearchBox"]
                $searchBox.ApplyTemplate()
                $placeholder = $searchBox.Template.FindName("PlaceholderText", $searchBox)
                if ($placeholder) {
                    $placeholder.Text = "Search applications..."
                }
            }
        } catch {
            Write-Log "Exception setting default tab appearance: $($_.Exception.Message)" -Level "ERROR"
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