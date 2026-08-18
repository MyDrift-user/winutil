function Enable-WinUtilSmoothScroll {
    <#
        .SYNOPSIS
            Makes a ScrollViewer glide to its destination instead of jumping there

        .DESCRIPTION
            A wheel notch normally moves a ScrollViewer straight to its new offset, which reads
            as a jump. This keeps a target offset and walks the real one towards it a frame at a
            time, so a notch reads as movement and several notches in a row accumulate rather
            than fighting each other.

            CompositionTarget.Rendering is used rather than a timer, because it fires once per
            frame in step with WPF's own compositor: a timer would either tick during a frame
            that is not being drawn or miss one that is. The handler is attached only while a
            glide is running, so an idle list costs nothing.

            Keyboard, scrollbar and touch scrolling are left alone. They are already continuous,
            and animating them would fight the input rather than smooth it.

        .PARAMETER ScrollViewer
            The ScrollViewer to animate.

        .PARAMETER NotchSize
            How far one wheel notch travels, in pixels.

        .PARAMETER Smoothing
            Fraction of the remaining distance covered each frame, between 0 and 1. Higher is
            faster and closer to the old jump.
    #>
    param(
        [Parameter(Mandatory)]
        $ScrollViewer,

        [double]$NotchSize = 120,

        [double]$Smoothing = 0.22
    )

    # Logical scrolling moves a whole row at a time, so there is nothing between one row and the
    # next to animate. Pixel scrolling is what makes a partial step possible at all.
    $ScrollViewer.CanContentScroll = $false

    $state = @{
        Target    = 0.0
        Animating = $false
        Handler   = $null
    }

    $state.Handler = {
        $current = $ScrollViewer.VerticalOffset
        $distance = $state.Target - $current

        # Close enough that another frame would not be visible: land exactly and stop, so the
        # per-frame handler is not left running behind an idle list
        if ([Math]::Abs($distance) -lt 0.5) {
            $ScrollViewer.ScrollToVerticalOffset($state.Target)
            [System.Windows.Media.CompositionTarget]::remove_Rendering($state.Handler)
            $state.Animating = $false
            return
        }

        $ScrollViewer.ScrollToVerticalOffset($current + ($distance * $Smoothing))
    }.GetNewClosure()

    $ScrollViewer.Add_PreviewMouseWheel({
        param($eventSender, $wheelArgs)

        # Anything nested that scrolls itself keeps its own behaviour
        if ($wheelArgs.Handled) { return }

        # Start from where the view actually is, unless a glide is already running: mid-glide the
        # target is ahead of the offset, and reading the offset would discard the rest of it
        $from = if ($state.Animating) { $state.Target } else { $ScrollViewer.VerticalOffset }

        $notches = $wheelArgs.Delta / 120
        $proposed = $from - ($notches * $NotchSize)

        # Clamped, or repeated notches at either end build up a target far outside the content
        # and the list appears to ignore the first few notches back
        $state.Target = [Math]::Max(0, [Math]::Min($proposed, $ScrollViewer.ScrollableHeight))

        if (-not $state.Animating) {
            $state.Animating = $true
            [System.Windows.Media.CompositionTarget]::add_Rendering($state.Handler)
        }

        $wheelArgs.Handled = $true
    }.GetNewClosure())
}
