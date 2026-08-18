#===========================================================================
# Tests - Smooth scrolling on the app list
#===========================================================================

BeforeAll {
    $script:repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName PresentationCore
    Add-Type -AssemblyName WindowsBase

    . (Join-Path $script:repoRoot "functions\private\Enable-WinUtilSmoothScroll.ps1")

    function script:New-TestScrollViewer {
        $viewer = New-Object Windows.Controls.ScrollViewer
        $viewer.CanContentScroll = $true
        $panel = New-Object Windows.Controls.StackPanel
        foreach ($row in 1..50) {
            $text = New-Object Windows.Controls.TextBlock
            $text.Text = "row $row"
            $text.Height = 24
            [void]$panel.Children.Add($text)
        }
        $viewer.Content = $panel
        return $viewer
    }

    function script:Send-Wheel {
        param($Viewer, [int]$Delta)

        $wheel = New-Object Windows.Input.MouseWheelEventArgs ([Windows.Input.Mouse]::PrimaryDevice), 0, $Delta
        $wheel.RoutedEvent = [Windows.UIElement]::PreviewMouseWheelEvent
        $Viewer.RaiseEvent($wheel)
        return $wheel
    }
}

Describe "Enable-WinUtilSmoothScroll" {
    It "switches the viewer to pixel scrolling" {
        # a logical scroll moves a whole row at a time, leaving nothing in between to animate
        $viewer = New-TestScrollViewer
        $viewer.CanContentScroll | Should -BeTrue

        Enable-WinUtilSmoothScroll -ScrollViewer $viewer

        $viewer.CanContentScroll | Should -BeFalse
    }

    It "takes over the wheel so the viewer does not also jump" {
        $viewer = New-TestScrollViewer
        Enable-WinUtilSmoothScroll -ScrollViewer $viewer

        (Send-Wheel -Viewer $viewer -Delta -120).Handled | Should -BeTrue
    }

    It "leaves a wheel event alone once something else has handled it" {
        $viewer = New-TestScrollViewer
        Enable-WinUtilSmoothScroll -ScrollViewer $viewer

        $wheel = New-Object Windows.Input.MouseWheelEventArgs ([Windows.Input.Mouse]::PrimaryDevice), 0, -120
        $wheel.RoutedEvent = [Windows.UIElement]::PreviewMouseWheelEvent
        $wheel.Handled = $true
        $viewer.RaiseEvent($wheel)

        # nothing to assert beyond it not throwing: a nested scroller keeps its own behaviour
        $wheel.Handled | Should -BeTrue
    }
}
