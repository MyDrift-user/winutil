function Populate-UI {
    <#
    .SYNOPSIS
    Populates the UI with data from configuration files
    
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
        Write-Log "Populating UI with configuration data..." -Level "DEBUG"
        
        # Populate applications
        if ($Sync) {
            Populate-Applications -AppsConfig $AppsConfig -Sync $Sync
            Populate-Tweaks -TweaksConfig $TweaksConfig -Sync $Sync
            Populate-Presets -PresetsConfig $PresetsConfig -Sync $Sync
        } else {
            # Fallback to old method
            Populate-Applications -Window $Window -AppsConfig $AppsConfig
            Populate-Tweaks -Window $Window -TweaksConfig $TweaksConfig
            Populate-Presets -Window $Window -PresetsConfig $PresetsConfig
        }
        
        Write-Log "UI population completed successfully" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception during UI population: $($_.Exception.Message)" -Level "ERROR"
        throw
    }
}

function Populate-Applications {
    <#
    .SYNOPSIS
    Populates the applications tree view grouped by categories
    
    .PARAMETER Window
    The WPF window object (deprecated - use Sync instead)
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        Write-Log "Populating applications tree..." -Level "DEBUG"
        
        # Get UI controls - use Sync if available, otherwise fallback to Window
        if ($Sync) {
            $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        } else {
            $trvApplications = $Window.FindName("trvApplications")
        }
        
        if (-not $trvApplications) {
            Write-Log "Could not find applications tree control" -Level "ERROR"
            return
        }
        
        # Group applications by category
        $appsByCategory = @{}
        $categories = @()
        
        foreach ($appProperty in $AppsConfig.PSObject.Properties) {
            $app = $appProperty.Value | Add-Member -MemberType NoteProperty -Name "ID" -Value $appProperty.Name -PassThru
            $category = if ($app.category) { $app.category } else { "Other" }
            
            if (-not $appsByCategory.ContainsKey($category)) {
                $appsByCategory[$category] = @()
                $categories += $category
            }
            
            $appsByCategory[$category] += $app
        }
        
        # Clear and populate tree
        $trvApplications.Items.Clear()
        
        foreach ($category in $categories | Sort-Object) {
            # Create category node
            $categoryNode = New-Object System.Windows.Controls.TreeViewItem
            $categoryNode.Header = $category
            $categoryNode.IsExpanded = $true
            
            # Add applications to category
            foreach ($app in $appsByCategory[$category] | Sort-Object Content) {
                $appNode = New-Object System.Windows.Controls.TreeViewItem
                $appNode.Style = $trvApplications.FindResource("CheckboxTreeViewItem")
                
                # Create checkbox with tooltip for description
                $checkBox = New-Object System.Windows.Controls.CheckBox
                $checkBox.Content = $app.Content
                $checkBox.Tag = $app.ID
                $checkBox.Foreground = [System.Windows.Media.Brushes]::White
                $checkBox.Margin = "0,4,0,4"
                
                # Add tooltip with description if available
                if ($app.Description) {
                    $checkBox.ToolTip = $app.Description
                }
                
                $appNode.Header = $checkBox
                $categoryNode.Items.Add($appNode)
            }
            
            $trvApplications.Items.Add($categoryNode)
        }
        
        $totalApps = ($appsByCategory.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
        Write-Log "Populated $totalApps applications in $($categories.Count) categories" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception populating applications: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Populate-Tweaks {
    <#
    .SYNOPSIS
    Populates the tweaks tree view and categories
    
    .PARAMETER Window
    The WPF window object (deprecated - use Sync instead)
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        Write-Log "Populating tweaks tree..." -Level "DEBUG"
        
        # Get UI controls - use Sync if available, otherwise fallback to Window
        if ($Sync) {
            $trvTweaks = Get-UIControl -Sync $Sync -ControlName "trvTweaks"
        } else {
            $trvTweaks = $Window.FindName("trvTweaks")
        }
        
        if (-not $trvTweaks) {
            Write-Log "Could not find tweaks tree control" -Level "ERROR"
            return
        }
        
        # Group tweaks by category
        $tweaksByCategory = @{}
        $categories = @()
        
        foreach ($tweakProperty in $TweaksConfig.PSObject.Properties) {
            $tweak = $tweakProperty.Value | Add-Member -MemberType NoteProperty -Name "ID" -Value $tweakProperty.Name -PassThru
            $category = if ($tweak.category) { $tweak.category } else { "Other" }
            
            if (-not $tweaksByCategory.ContainsKey($category)) {
                $tweaksByCategory[$category] = @()
                $categories += $category
            }
            
            $tweaksByCategory[$category] += $tweak
        }
        
        # Clear and populate tree
        $trvTweaks.Items.Clear()
        
        foreach ($category in $categories | Sort-Object) {
            # Create category node
            $categoryNode = New-Object System.Windows.Controls.TreeViewItem
            $categoryNode.Header = $category
            $categoryNode.IsExpanded = $true
            
            # Add tweaks to category
            foreach ($tweak in $tweaksByCategory[$category] | Sort-Object Content) {
                $tweakNode = New-Object System.Windows.Controls.TreeViewItem
                $tweakNode.Style = $trvTweaks.FindResource("CheckboxTreeViewItem")
                
                # Determine the control type (default to checkbox if not specified)
                $controlType = if ($tweak.Type) { $tweak.Type } else { "Checkbox" }
                
                switch ($controlType.ToLower()) {
                    "toggle" {
                        # Create toggle switch (CheckBox styled as toggle)
                        $toggleSwitch = New-Object System.Windows.Controls.CheckBox
                        $toggleSwitch.Content = $tweak.Content
                        $toggleSwitch.Tag = $tweak.ID
                        $toggleSwitch.Style = $trvTweaks.FindResource("ToggleSwitch")
                        
                        # Set initial state based on DefaultState if available
                        if ($tweak.registry -and $tweak.registry[0].DefaultState) {
                            $toggleSwitch.IsChecked = [bool]::Parse($tweak.registry[0].DefaultState)
                        }
                        
                        # Add tooltip with description if available
                        if ($tweak.Description) {
                            $toggleSwitch.ToolTip = $tweak.Description
                        }
                        
                        # Add immediate execution event handler
                        $toggleSwitch.Add_Checked({
                            param($sender, $e)
                            $tweakId = $sender.Tag
                            Write-Log "Toggle ON: $tweakId" -Level "INFO"
                            # Execute tweak immediately
                            Invoke-TweakExecution -TweakId $tweakId -Action "Apply"
                        })
                        
                        $toggleSwitch.Add_Unchecked({
                            param($sender, $e)
                            $tweakId = $sender.Tag
                            Write-Log "Toggle OFF: $tweakId" -Level "INFO"
                            # Execute undo immediately
                            Invoke-TweakExecution -TweakId $tweakId -Action "Undo"
                        })
                        
                        $tweakNode.Header = $toggleSwitch
                    }
                    
                    "button" {
                        # Create button
                        $button = New-Object System.Windows.Controls.Button
                        $button.Content = $tweak.Content
                        $button.Tag = $tweak.ID
                        $button.Style = $trvTweaks.FindResource("TweakButton")
                        
                        # Set custom width if specified
                        if ($tweak.ButtonWidth) {
                            $button.Width = [int]$tweak.ButtonWidth
                        }
                        
                        # Add tooltip with description if available
                        if ($tweak.Description) {
                            $button.ToolTip = $tweak.Description
                        }
                        
                        # Add immediate execution event handler
                        $button.Add_Click({
                            param($sender, $e)
                            $tweakId = $sender.Tag
                            Write-Log "Button clicked: $tweakId" -Level "INFO"
                            # Execute tweak immediately
                            Invoke-TweakExecution -TweakId $tweakId -Action "Apply"
                        })
                        
                        $tweakNode.Header = $button
                    }
                    
                    "combobox" {
                        # Create container for combobox with label
                        $container = New-Object System.Windows.Controls.StackPanel
                        $container.Orientation = [System.Windows.Controls.Orientation]::Vertical
                        
                        # Create label
                        $label = New-Object System.Windows.Controls.TextBlock
                        $label.Text = $tweak.Content
                        $label.Foreground = [System.Windows.Media.Brushes]::White
                        $label.FontSize = 14
                        $label.Margin = "0,0,0,4"
                        
                        # Create combobox
                        $comboBox = New-Object System.Windows.Controls.ComboBox
                        $comboBox.Tag = $tweak.ID
                        $comboBox.Style = $trvTweaks.FindResource("TweakComboBox")
                        
                        # Add items from ComboItems property
                        if ($tweak.ComboItems) {
                            $items = $tweak.ComboItems -split ' '
                            foreach ($item in $items) {
                                $comboBox.Items.Add($item) | Out-Null
                            }
                            # Select first item by default
                            if ($comboBox.Items.Count -gt 0) {
                                $comboBox.SelectedIndex = 0
                            }
                        }
                        
                        # Add tooltip with description if available
                        if ($tweak.Description) {
                            $container.ToolTip = $tweak.Description
                        }
                        
                        # Add immediate execution event handler
                        $comboBox.Add_SelectionChanged({
                            param($sender, $e)
                            if ($sender.SelectedItem) {
                                $tweakId = $sender.Tag
                                $selectedValue = $sender.SelectedItem.ToString()
                                Write-Log "ComboBox changed: $tweakId = $selectedValue" -Level "INFO"
                                # Execute tweak immediately with selected value
                                Invoke-TweakExecution -TweakId $tweakId -Action "Apply" -Value $selectedValue
                            }
                        })
                        
                        $container.Children.Add($label) | Out-Null
                        $container.Children.Add($comboBox) | Out-Null
                        $tweakNode.Header = $container
                    }
                    
                    default {
                        # Create standard checkbox (default behavior)
                        $checkBox = New-Object System.Windows.Controls.CheckBox
                        $checkBox.Content = $tweak.Content
                        $checkBox.Tag = $tweak.ID
                        $checkBox.Foreground = [System.Windows.Media.Brushes]::White
                        $checkBox.Margin = "0,4,0,4"
                        
                        # Add tooltip with description if available
                        if ($tweak.Description) {
                            $checkBox.ToolTip = $tweak.Description
                        }
                        
                        $tweakNode.Header = $checkBox
                    }
                }
                
                $categoryNode.Items.Add($tweakNode)
            }
            
            $trvTweaks.Items.Add($categoryNode)
        }
        
        $totalTweaks = ($tweaksByCategory.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
        Write-Log "Populated $totalTweaks tweaks in $($categories.Count) categories" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception populating tweaks: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Populate-Presets {
    <#
    .SYNOPSIS
    Populates the preset dropdown menus
    
    .PARAMETER Window
    The WPF window object (deprecated - use Sync instead)
    
    .PARAMETER PresetsConfig
    The presets configuration object
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$PresetsConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        Write-Log "Populating presets..." -Level "DEBUG"
        
        # Presets are now handled by buttons, so this function doesn't need to do anything
        Write-Log "Preset buttons will be handled by event handlers" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception populating presets: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Filter-Content {
    <#
    .SYNOPSIS
    Filters both applications and tweaks based on search text
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER SearchText
    Text to search for
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [string]$SearchText = ""
    )
    
    try {
        # Filter applications (collapse/expand categories based on search)
        $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        if ($trvApplications) {
            foreach ($categoryNode in $trvApplications.Items) {
                $hasVisibleApps = $false
                
                foreach ($appNode in $categoryNode.Items) {
                    $checkBox = $appNode.Header
                    if ($checkBox -is [System.Windows.Controls.CheckBox]) {
                        $appVisible = -not $SearchText -or 
                                     ($checkBox.Content -and $checkBox.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                     ($checkBox.ToolTip -and $checkBox.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                        
                        $appNode.Visibility = if ($appVisible) { "Visible" } else { "Collapsed" }
                        if ($appVisible) { $hasVisibleApps = $true }
                    }
                }
                
                $categoryNode.Visibility = if ($hasVisibleApps) { "Visible" } else { "Collapsed" }
                if ($hasVisibleApps -and $SearchText) {
                    $categoryNode.IsExpanded = $true
                }
            }
        }
        
        # Filter tweaks (collapse/expand categories based on search)
        $trvTweaks = Get-UIControl -Sync $Sync -ControlName "trvTweaks"
        if ($trvTweaks) {
            foreach ($categoryNode in $trvTweaks.Items) {
                $hasVisibleTweaks = $false
                
                foreach ($tweakNode in $categoryNode.Items) {
                    $control = $tweakNode.Header
                    $tweakVisible = $false
                    
                    # Handle different control types for filtering
                    if ($control -is [System.Windows.Controls.CheckBox]) {
                        # Checkbox or Toggle
                        $tweakVisible = -not $SearchText -or 
                                       ($control.Content -and $control.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                       ($control.ToolTip -and $control.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                    }
                    elseif ($control -is [System.Windows.Controls.Button]) {
                        # Button
                        $tweakVisible = -not $SearchText -or 
                                       ($control.Content -and $control.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                       ($control.ToolTip -and $control.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                    }
                    elseif ($control -is [System.Windows.Controls.StackPanel]) {
                        # ComboBox container
                        $label = $control.Children | Where-Object { $_ -is [System.Windows.Controls.TextBlock] } | Select-Object -First 1
                        $tweakVisible = -not $SearchText -or 
                                       ($label -and $label.Text -and $label.Text.ToLower().Contains($SearchText.ToLower())) -or
                                       ($control.ToolTip -and $control.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                    }
                    
                    $tweakNode.Visibility = if ($tweakVisible) { "Visible" } else { "Collapsed" }
                    if ($tweakVisible) { $hasVisibleTweaks = $true }
                }
                
                $categoryNode.Visibility = if ($hasVisibleTweaks) { "Visible" } else { "Collapsed" }
                if ($hasVisibleTweaks -and $SearchText) {
                    $categoryNode.IsExpanded = $true
                }
            }
        }
        
        Write-Log "Content filtered for search: '$SearchText'" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception filtering content: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Filter-ApplicationContent {
    <#
    .SYNOPSIS
    Filters applications based on search text
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER SearchText
    Text to search for
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$false)]
        [string]$SearchText = ""
    )
    
    try {
        # Filter applications (collapse/expand categories based on search)
        $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        if ($trvApplications) {
            foreach ($categoryNode in $trvApplications.Items) {
                $hasVisibleApps = $false
                
                foreach ($appNode in $categoryNode.Items) {
                    $checkBox = $appNode.Header
                    if ($checkBox -is [System.Windows.Controls.CheckBox]) {
                        $appVisible = -not $SearchText -or 
                                     ($checkBox.Content -and $checkBox.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                     ($checkBox.ToolTip -and $checkBox.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                        
                        $appNode.Visibility = if ($appVisible) { "Visible" } else { "Collapsed" }
                        if ($appVisible) { $hasVisibleApps = $true }
                    }
                }
                
                $categoryNode.Visibility = if ($hasVisibleApps) { "Visible" } else { "Collapsed" }
                if ($hasVisibleApps -and $SearchText) {
                    $categoryNode.IsExpanded = $true
                }
            }
        }
        
        Write-Log "Applications filtered for search: '$SearchText'" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception filtering applications: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Filter-TweakContent {
    <#
    .SYNOPSIS
    Filters tweaks based on search text
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER SearchText
    Text to search for
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [string]$SearchText = ""
    )
    
    try {
        # Filter tweaks (collapse/expand categories based on search)
        $trvTweaks = Get-UIControl -Sync $Sync -ControlName "trvTweaks"
        if ($trvTweaks) {
            foreach ($categoryNode in $trvTweaks.Items) {
                $hasVisibleTweaks = $false
                
                foreach ($tweakNode in $categoryNode.Items) {
                    $stackPanel = $tweakNode.Header
                    if ($stackPanel -is [System.Windows.Controls.StackPanel]) {
                        $checkBox = $stackPanel.Children | Where-Object { $_ -is [System.Windows.Controls.CheckBox] } | Select-Object -First 1
                        if ($checkBox) {
                            $tweakVisible = -not $SearchText -or 
                                           ($checkBox.Content -and $checkBox.Content.ToString().ToLower().Contains($SearchText.ToLower()))
                            
                            $tweakNode.Visibility = if ($tweakVisible) { "Visible" } else { "Collapsed" }
                            if ($tweakVisible) { $hasVisibleTweaks = $true }
                        }
                    }
                }
                
                $categoryNode.Visibility = if ($hasVisibleTweaks) { "Visible" } else { "Collapsed" }
                if ($hasVisibleTweaks -and $SearchText) {
                    $categoryNode.IsExpanded = $true
                }
            }
        }
        
        Write-Log "Tweaks filtered for search: '$SearchText'" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception filtering tweaks: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Get-SelectedApplications {
    <#
    .SYNOPSIS
    Gets the currently selected applications from the UI
    #>
    param(
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        if ($Sync) {
            $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        } else {
            $trvApplications = $Window.FindName("trvApplications")
        }
        
        if (-not $trvApplications) { return @() }
        
        $selectedApps = @()
        
        # Recursively traverse tree and find checked items
        foreach ($categoryNode in $trvApplications.Items) {
            foreach ($appNode in $categoryNode.Items) {
                $checkBox = $appNode.Header
                if ($checkBox -is [System.Windows.Controls.CheckBox] -and $checkBox.IsChecked -and $checkBox.Tag) {
                    $selectedApps += $checkBox.Tag
                }
            }
        }
        
        return $selectedApps
    }
    catch {
        Write-Log "Exception getting selected applications: $($_.Exception.Message)" -Level "ERROR"
        return @()
    }
}

function Get-SelectedTweaks {
    <#
    .SYNOPSIS
    Gets the currently selected tweaks from the UI
    #>
    param(
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
        
        if (-not $trvTweaks) { return @() }
        
        $selectedTweaks = @()
        
        # Recursively traverse tree and find checked items (only checkboxes, not toggles/buttons)
        foreach ($categoryNode in $trvTweaks.Items) {
            foreach ($tweakNode in $categoryNode.Items) {
                $control = $tweakNode.Header
                # Only include standard checkboxes in bulk selection, not toggles/buttons/comboboxes
                if ($control -is [System.Windows.Controls.CheckBox] -and 
                    $control.Style -eq $null -and  # Standard checkbox (not toggle)
                    $control.IsChecked -and 
                    $control.Tag) {
                    $selectedTweaks += $control.Tag
                }
            }
        }
        
        return $selectedTweaks
    }
    catch {
        Write-Log "Exception getting selected tweaks: $($_.Exception.Message)" -Level "ERROR"
        return @()
    }
}

function Set-UIEnabled {
    <#
    .SYNOPSIS
    Enables or disables the UI during operations
    #>
    param(
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [bool]$Enabled
    )
    
    try {
        # List of controls to enable/disable
        $controlNames = @(
            "btnInstallApps", "btnUninstallApps", "btnApplyTweaks", "btnUndoTweaks",
            "btnPresetStandard", "btnPresetMinimal", "btnClearSelection"
        )
        
        foreach ($controlName in $controlNames) {
            if ($Sync) {
                $control = Get-UIControl -Sync $Sync -ControlName $controlName
            } else {
                $control = $Window.FindName($controlName)
            }
            
            if ($control) {
                $control.IsEnabled = $Enabled
            }
        }
        
        # Update cursor
        if ($Sync -and $Sync["Form"]) {
            $Sync["Form"].Cursor = if ($Enabled) { [System.Windows.Input.Cursors]::Arrow } else { [System.Windows.Input.Cursors]::Wait }
        } elseif ($Window) {
            $Window.Cursor = if ($Enabled) { [System.Windows.Input.Cursors]::Arrow } else { [System.Windows.Input.Cursors]::Wait }
        }
    }
    catch {
        Write-Log "Exception setting UI enabled state: $($_.Exception.Message)" -Level "ERROR"
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

function Initialize-UIControls {
    <#
    .SYNOPSIS
    Automatically binds all named UI controls to a sync hashtable for easy access
    
    .PARAMETER Window
    The WPF window object
    
    .PARAMETER Sync
    The sync hashtable to store control references
    
    .PARAMETER XamlContent
    The XAML content string to parse for named controls
    #>
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [string]$XamlContent
    )
    
    try {
        Write-Log "Initializing UI control bindings..." -Level "DEBUG"
        
        # Store the window reference
        $Sync["Form"] = $Window
        
        # Parse XAML and find all named elements
        $xamlDoc = [System.Xml.XmlDocument]::new()
        $xamlDoc.LoadXml($XamlContent)
        
        # Find all elements with Name attributes
        $namedElements = $xamlDoc.SelectNodes("//*[@Name]")
        
        $boundControls = 0
        foreach ($element in $namedElements) {
            $controlName = $element.GetAttribute("Name")
            if ($controlName) {
                try {
                    $control = $Window.FindName($controlName)
                    if ($control) {
                        $Sync[$controlName] = $control
                        $boundControls++
                        Write-Log "Bound control: $controlName" -Level "DEBUG"
                    } else {
                        Write-Log "Control not found: $controlName" -Level "WARN"
                    }
                } catch {
                    Write-Log "Error binding control '$controlName': $($_.Exception.Message)" -Level "WARN"
                }
            }
        }
        
        Write-Log "UI control binding completed: $boundControls controls bound" -Level "DEBUG"
        return $boundControls
    }
    catch {
        Write-Log "Exception during UI control initialization: $($_.Exception.Message)" -Level "ERROR"
        throw
    }
}

function Get-UIControl {
    <#
    .SYNOPSIS
    Gets a UI control from the sync hashtable with error handling
    
    .PARAMETER Sync
    The sync hashtable containing control references
    
    .PARAMETER ControlName
    The name of the control to retrieve
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [string]$ControlName
    )
    
    if ($Sync.ContainsKey($ControlName)) {
        return $Sync[$ControlName]
    } else {
        Write-Log "UI control '$ControlName' not found in sync hashtable" -Level "WARN"
        return $null
    }
}

function Invoke-TweakExecution {
    <#
    .SYNOPSIS
    Executes a tweak immediately when triggered by buttons or toggles
    
    .PARAMETER TweakId
    The ID of the tweak to execute
    
    .PARAMETER Action
    The action to perform (Apply or Undo)
    
    .PARAMETER Value
    Optional value for combobox selections
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$TweakId,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet("Apply", "Undo")]
        [string]$Action,
        
        [Parameter(Mandatory=$false)]
        [string]$Value
    )
    
    try {
        Write-Log "Executing tweak: $TweakId ($Action)" -Level "INFO"
        
        # This is a placeholder for the actual tweak execution logic
        # In the real implementation, this would:
        # 1. Load the tweak configuration
        # 2. Execute registry changes, scripts, service modifications, etc.
        # 3. Handle the specific value for combobox tweaks
        
        # For now, just log the action
        if ($Value) {
            Write-Log "Tweak $TweakId executed with value: $Value" -Level "INFO"
        } else {
            Write-Log "Tweak $TweakId executed ($Action)" -Level "INFO"
        }
        
        # TODO: Implement actual tweak execution logic here
        # This would typically involve calling existing tweak functions
        # based on the TweakId and Action parameters
        
    }
    catch {
        Write-Log "Error executing tweak $TweakId`: $($_.Exception.Message)" -Level "ERROR"
    }
}

# Functions exported: Initialize-UIControls, Get-UIControl, Populate-UI, Populate-Applications, Populate-Tweaks, Populate-Presets, Filter-Applications 