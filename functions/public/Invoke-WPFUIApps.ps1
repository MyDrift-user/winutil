function Invoke-WPFUIApps {
    param(
        [Parameter(Mandatory, Position = 0)]
        [PSCustomObject]$Objects,

        [Parameter(Mandatory, Position = 1)]
        [string]$targetGridName,
        [System.Boolean]$alphabetical = $False


    )
    function setup-StackPanel{
        $targetGrid = $window.FindName($targetGridName)
        $borderstyle = $window.FindResource("BorderStyle")

        # Clear existing Children
        $targetGrid.Children.Clear() | Out-Null

        # Create a Border
        $border = New-Object Windows.Controls.Border
        $border.VerticalAlignment = "Stretch" # Ensure the border stretches vertically
        $border.style = $borderstyle

        $targetGrid.Children.Add($border) | Out-Null
        return $targetGrid

    }
    function setup-Header {
        param(
            $targetGrid
        )
        $border = $targetGrid.Children[0]
        $dockPanelContainer = New-Object Windows.Controls.DockPanel
        $border.Child = $dockPanelContainer

        # Helper function to create buttons
        function New-WPFButton {
            param (
                [string]$Name,
                [string]$Content
            )
            $button = New-Object Windows.Controls.Button
            $button.Name = $Name
            $button.Content = $Content
            $button.Margin = New-Object Windows.Thickness(2)
            $button.HorizontalAlignment = "Stretch"
            return $button
        }

        # Create a WrapPanel to hold buttons at the top
        $wrapPanelTop = New-Object Windows.Controls.WrapPanel
        $wrapPanelTop.SetResourceReference([Windows.Controls.Control]::BackgroundProperty, "MainBackgroundColor")
        $wrapPanelTop.HorizontalAlignment = "Left"
        $wrapPanelTop.VerticalAlignment = "Top"
        $wrapPanelTop.Orientation = "Horizontal"
        $wrapPanelTop.Margin = $window.FindResource("TabContentMargin")

        # Create buttons and add them to the WrapPanel with dynamic widths
        $buttonConfigs = @(
            @{Name="WPFInstall"; Content="Install/Upgrade Selected"},
            @{Name="WPFInstallUpgrade"; Content="Upgrade All"},
            @{Name="WPFUninstall"; Content="Uninstall Selected"}
        )

        foreach ($config in $buttonConfigs) {
            $button = New-WPFButton -Name $config.Name -Content $config.Content
            $wrapPanelTop.Children.Add($button) | Out-Null
            $sync[$config.Name] = $button
        }

        $selectedLabel = New-Object Windows.Controls.Label
        $selectedLabel.Name = "WPFSelectedLabel"
        $selectedLabel.Content = "Selected Apps: 0"
        $selectedLabel.SetResourceReference([Windows.Controls.Control]::FontSizeProperty, "FontSizeHeading")
        $selectedLabel.SetResourceReference([Windows.Controls.Control]::MarginProperty, "TabContentMargin")
        $selectedLabel.SetResourceReference([Windows.Controls.Control]::ForegroundProperty, "MainForegroundColor")
        $selectedLabel.HorizontalAlignment = "Center"
        $selectedLabel.VerticalAlignment = "Center"

        $wrapPanelTop.Children.Add($selectedLabel) | Out-null
        $sync.$($selectedLabel.Name) = $selectedLabel

        # Dock the WrapPanel at the top of the DockPanel
        [Windows.Controls.DockPanel]::SetDock($wrapPanelTop, [Windows.Controls.Dock]::Top)
        $dockPanelContainer.Children.Add($wrapPanelTop) | Out-Null
        return $dockPanelContainer
    }

    function setup-AppArea {
        param(
            $targetGrid
        )
        # Create a ScrollViewer to contain the main content (excluding buttons)
        $scrollViewer = New-Object Windows.Controls.ScrollViewer
        $scrollViewer.VerticalScrollBarVisibility = 'Auto'
        $scrollViewer.HorizontalAlignment = 'Stretch'
        $scrollViewer.VerticalAlignment = 'Stretch'
        $scrollViewer.CanContentScroll = $true  # Enable virtualization

        # Create an ItemsControl inside the ScrollViewer for application content
        $itemsControl = New-Object Windows.Controls.ItemsControl
        $itemsControl.HorizontalAlignment = 'Stretch'
        $itemsControl.VerticalAlignment = 'Stretch'


        # Set the ItemsPanel to a VirtualizingStackPanel
        $itemsPanelTemplate = New-Object Windows.Controls.ItemsPanelTemplate
        $factory = New-Object Windows.FrameworkElementFactory ([Windows.Controls.VirtualizingStackPanel])
        $itemsPanelTemplate.VisualTree = $factory
        $itemsControl.ItemsPanel = $itemsPanelTemplate

        # Set virtualization properties
        $itemsControl.SetValue([Windows.Controls.VirtualizingStackPanel]::IsVirtualizingProperty, $true)
        $itemsControl.SetValue([Windows.Controls.VirtualizingStackPanel]::VirtualizationModeProperty, [Windows.Controls.VirtualizationMode]::Recycling)

        # Add the ItemsControl to the ScrollViewer
        $scrollViewer.Content = $itemsControl

        # Add the ScrollViewer to the DockPanel (it will be below the top buttons StackPanel)
        [Windows.Controls.DockPanel]::SetDock($scrollViewer, [Windows.Controls.Dock]::Bottom)
        $targetGrid.Children.Add($scrollViewer) | Out-Null
        return $itemsControl
    }
    function AddCategoryLabel {
        param(
            [string]$category,
            $itemsControl
        )

        $stackPanel = New-Object Windows.Controls.StackPanel
        $stackPanel.Orientation = [Windows.Controls.Orientation]::Horizontal

        $textBlock = New-Object Windows.Controls.TextBlock
        $textBlock.Text = "[+] "
        $textBlock.SetResourceReference([Windows.Controls.Control]::FontSizeProperty, "FontSizeHeading")
        $textBlock.SetResourceReference([Windows.Controls.Control]::FontFamilyProperty, "HeaderFontFamily")
        $textBlock.VerticalAlignment = "Center"
        $stackPanel.Children.Add($textBlock)

        $categoryTextBlock = New-Object Windows.Controls.TextBlock
        $categoryTextBlock.Text = $category
        $categoryTextBlock.SetResourceReference([Windows.Controls.Control]::FontSizeProperty, "FontSizeHeading")
        $categoryTextBlock.SetResourceReference([Windows.Controls.Control]::FontFamilyProperty, "HeaderFontFamily")
        $categoryTextBlock.VerticalAlignment = "Center"
        $stackPanel.Children.Add($categoryTextBlock)
        $stackPanel.Cursor = [System.Windows.Input.Cursors]::Hand

        # Add click event to toggle visibility
        $stackPanel.Add_MouseUp({
            $itemsControl = $this.Parent
            $appsInCategory = $itemsControl.Items | Where-Object { $_.Tag.category -eq $this.Children[1].Text }
            $isCollapsed = $appsInCategory[0].Visibility -eq [Windows.Visibility]::Visible
            foreach ($appEntry in $appsInCategory) {
                $appEntry.Visibility = if ($isCollapsed) {
                    [Windows.Visibility]::Collapsed
                } else {
                    [Windows.Visibility]::Visible
                }
            }
            # Update the indicator
            $this.Children[0].Text = if ($isCollapsed) { "[+] " } else { "[-] " }
        })
        $itemsControl.Items.Add($stackPanel) | Out-Null
    }
    function createCategoryAppList {
        param(
            $targetGrid,
            $Apps,
            [System.Boolean]$alphabetical
        )

        # Create a loading message
        $loadingLabel = New-Object Windows.Controls.Label
        $loadingLabel.Content = "Loading, please wait..."
        $loadingLabel.HorizontalAlignment = "Center"
        $loadingLabel.VerticalAlignment = "Center"
        $loadingLabel.FontSize = 16
        $loadingLabel.FontWeight = [Windows.FontWeights]::Bold
        $loadingLabel.Foreground = [Windows.Media.Brushes]::Gray

        # Add the loading message to the items control
        $itemsControl.Items.Clear()
        $itemsControl.Items.Add($loadingLabel) | Out-Null

        # Use a single UI update batch
        $itemsControl.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [action]{
            # Clear the loading message
            $itemsControl.Items.Clear()

            if (-not ($alphabetical)) {
                $categories = $Apps | Select-Object -ExpandProperty category -Unique | Sort-Object
                foreach ($category in $categories) {
                    AddCategoryLabel -category $category -itemsControl $itemsControl
                    foreach ($App in $Apps | Where-Object {$_.category -eq $category}) {
                        createAppEntry -itemsControl $itemsControl -app $app -hidden $true
                    }
                }
            } else {

                foreach ($App in $Apps) {
                    createAppEntry -itemsControl $itemsControl -app $app -hidden $false
                }
            }
        })
        if ($sync.SelectedApps) {
            $sync.ItemsControl.Items | Where-Object {
                $_.Tag.name -in $sync.SelectedApps
            } | ForEach-Object {
                # Neccesary so no duplicates are added
                $sync.SelectedApps.Remove($_.Tag.name)
                $_.Child.Children[0].IsChecked = $true
            }
        }
    }
    function createAppEntry {
        param(
            $itemsControl,
            $app,
            [bool]$hidden
        )
        # Create the outer Border for the application type
        $border = New-Object Windows.Controls.Border
        $border.BorderBrush = [Windows.Media.Brushes]::Gray
        $border.BorderThickness = 1
        $border.CornerRadius = 5
        $border.Padding = New-Object Windows.Thickness(10)
        $border.HorizontalAlignment = "Stretch"
        $border.VerticalAlignment = "Top"
        $border.Margin = New-Object Windows.Thickness(0, 10, 0, 0)
        $border.SetResourceReference([Windows.Controls.Control]::BackgroundProperty, "AppInstallUnselectedColor")
        $border.Tag = [PSCustomObject]@{
            name = $app.Name
            category = $app.category
        }
        $border.Visibility = if ($hidden) {[Windows.Visibility]::Collapsed} else {[Windows.Visibility]::Visible}
        $border.Add_MouseUp({
            $childCheckbox = ($this.Child.Children | Where-Object {$_.Template.TargetType -eq [System.Windows.Controls.Checkbox]})[0]
            $childCheckBox.isChecked = -not $childCheckbox.IsChecked
        })
        # Create a DockPanel inside the Border
        $dockPanel = New-Object Windows.Controls.DockPanel
        $dockPanel.LastChildFill = $true
        $border.Child = $dockPanel

        # Create the CheckBox, vertically centered
        $checkBox = New-Object Windows.Controls.CheckBox
        # $checkBox.Name = $app.Name
        $checkBox.Background = "Transparent"
        $checkBox.HorizontalAlignment = "Left"
        $checkBox.VerticalAlignment = "Center"
        $checkBox.Margin = New-Object Windows.Thickness(5, 0, 10, 0)
        $checkbox.Add_Checked({
            Invoke-WPFSelectedLabelUpdate -type "Add" -checkbox $this
            $borderElement = $this.Parent.Parent
            $borderElement.SetResourceReference([Windows.Controls.Control]::BackgroundProperty, "AppInstallSelectedColor")
        })

        $checkbox.Add_Unchecked({
            Invoke-WPFSelectedLabelUpdate -type "Remove" -checkbox $this
            $borderElement = $this.Parent.Parent
            $borderElement.SetResourceReference([Windows.Controls.Control]::BackgroundProperty, "AppInstallUnselectedColor")
        })
        # Create a StackPanel for the image and name
        $imageAndNamePanel = New-Object Windows.Controls.StackPanel
        $imageAndNamePanel.Orientation = "Horizontal"
        $imageAndNamePanel.VerticalAlignment = "Center"

        # Create the Image and set a placeholder
        $image = New-Object Windows.Controls.Image
        # $image.Name = "wpfapplogo" + $app.Name
        $image.Width = 40
        $image.Height = 40
        $image.Margin = New-Object Windows.Thickness(0, 0, 10, 0)
        $image.Source = $noimage  # Ensure $noimage is defined in your script

        # Clip the image corners
        $image.Clip = New-Object Windows.Media.RectangleGeometry
        $image.Clip.Rect = New-Object Windows.Rect(0, 0, $image.Width, $image.Height)
        $image.Clip.RadiusX = 5
        $image.Clip.RadiusY = 5

        $imageAndNamePanel.Children.Add($image) | Out-Null

        # Create the TextBlock for the application name
        $appName = New-Object Windows.Controls.TextBlock
        $appName.Text = $app.Name
        $appName.FontSize = 16
        $appName.FontWeight = [Windows.FontWeights]::Bold
        $appName.VerticalAlignment = "Center"
        $appName.Margin = New-Object Windows.Thickness(5, 0, 0, 0)
        $appName.Background = "Transparent"
        $imageAndNamePanel.Children.Add($appName) | Out-Null

        # Add the image and name panel to the Checkbox
        $checkBox.Content = $imageAndNamePanel

        # Add the checkbox to the DockPanel
        [Windows.Controls.DockPanel]::SetDock($checkBox, [Windows.Controls.Dock]::Left)
        $dockPanel.Children.Add($checkBox) | Out-Null

        # Create the StackPanel for the buttons and dock it to the right
        $buttonPanel = New-Object Windows.Controls.StackPanel
        $buttonPanel.Orientation = "Horizontal"
        $buttonPanel.HorizontalAlignment = "Right"
        $buttonPanel.VerticalAlignment = "Center"
        $buttonPanel.Margin = New-Object Windows.Thickness(10, 0, 0, 0)
        [Windows.Controls.DockPanel]::SetDock($buttonPanel, [Windows.Controls.Dock]::Right)

        # Create the "Install" button
        $installButton = New-Object Windows.Controls.Button
        $installButton.Width = 45
        $installButton.Height = 35
        $installButton.Margin = New-Object Windows.Thickness(0, 0, 10, 0)

        $installIcon = New-Object Windows.Controls.TextBlock
        $installIcon.Text = [char]0xE118  # Install Icon
        $installIcon.FontFamily = "Segoe MDL2 Assets"
        $installIcon.FontSize = 20
        $installIcon.SetResourceReference([Windows.Controls.Control]::ForegroundProperty, "MainForegroundColor")
        $installIcon.Background = "Transparent"
        $installIcon.HorizontalAlignment = "Center"
        $installIcon.VerticalAlignment = "Center"

        $installButton.Content = $installIcon
        $buttonPanel.Children.Add($installButton) | Out-Null

        # Add Click event for the "Install" button
        $installButton.Add_Click({
            Write-Host "Installing $($app.Name) ..."
        })

        # Create the "Uninstall" button
        $uninstallButton = New-Object Windows.Controls.Button
        $uninstallButton.Width = 45
        $uninstallButton.Height = 35

        $uninstallIcon = New-Object Windows.Controls.TextBlock
        $uninstallIcon.Text = [char]0xE74D  # Uninstall Icon
        $uninstallIcon.FontFamily = "Segoe MDL2 Assets"
        $uninstallIcon.FontSize = 20
        $uninstallIcon.SetResourceReference([Windows.Controls.Control]::ForegroundProperty, "MainForegroundColor")
        $uninstallIcon.Background = "Transparent"
        $uninstallIcon.HorizontalAlignment = "Center"
        $uninstallIcon.VerticalAlignment = "Center"

        $uninstallButton.Content = $uninstallIcon
        $buttonPanel.Children.Add($uninstallButton) | Out-Null

        $uninstallButton.Add_Click({
            Write-Host "Uninstalling $($app.Name) ..."
        })

        # Create the "Info" button
        $infoButton = New-Object Windows.Controls.Button
        $infoButton.Width = 45
        $infoButton.Height = 35
        $infoButton.Margin = New-Object Windows.Thickness(10, 0, 0, 0)

        $infoIcon = New-Object Windows.Controls.TextBlock
        $infoIcon.Text = [char]0xE946  # Info Icon
        $infoIcon.FontFamily = "Segoe MDL2 Assets"
        $infoIcon.FontSize = 20
        $infoIcon.SetResourceReference([Windows.Controls.Control]::ForegroundProperty, "MainForegroundColor")
        $infoIcon.Background = "Transparent"
        $infoIcon.HorizontalAlignment = "Center"
        $infoIcon.VerticalAlignment = "Center"

        $infoButton.Content = $infoIcon
        $buttonPanel.Children.Add($infoButton) | Out-Null

        $infoButton.Add_Click({
            Write-Host "Getting info for $($app.Name) ..."
        })

        # Add the button panel to the DockPanel
        $dockPanel.Children.Add($buttonPanel) | Out-Null

        # Add the border to the main items control in the grid
        $itemsControl.Items.Add($border) | Out-Null
    }


    $window = $sync.Form

    switch ($targetGridName) {
        "appspanel"{
            $targetGrid = setup-StackPanel
            $dockPanelContainer = setup-Header -targetGrid $targetGrid
            $itemsControl = setup-AppArea -targetGrid $dockPanelContainer
            $sync.ItemsControl = $itemsControl
            createCategoryAppList -itemsControl $itemsControl -Apps $Objects -alphabetical $alphabetical
        }
        default {
            Write-Output "$targetGridName not yet implemented "
        }
    }

}
