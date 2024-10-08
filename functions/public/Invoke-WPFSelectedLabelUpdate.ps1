function Invoke-WPFSelectedLabelUpdate {
    <#
        .SYNOPSIS
            This is a helper function that is called by the Checked and Unchecked events of the Checkboxes on the install tab.
            It Updates the "Selected Apps" Label on the Install Tab to represent the current collection
        .PARAMETER type
            Eigther: Add | Remove
        .PARAMETER checkbox
            should contain the current instance of the checkbox that triggered the Event.
            Most of the time will be the automatic variable $this
        .EXAMPLE
            $checkbox.Add_Unchecked({Invoke-WPFSelectedLabelUpdate -type "Remove" -checkbox $this})
            OR
            Invoke-WPFSelectedLabelUpdate -type "Add" -checkbox $specificCheckbox
    #>
    param (
        $type,
        $checkbox
    )
    $selectedLabel = $sync.WPFSelectedLabel
    # Get the actual Name from the Label inside the Checkbox
    $app_name = $checkbox.Content.Children.Text
    if ($type -eq "Add") {
        $sync.selectedApps.Add($app_name)
        # The List type needs to be specified again, because otherwise Sort-Object will convert the list to a string if there is only a single entry
        [System.Collections.Generic.List[string]]$sync.selectedApps = $sync.SelectedApps | Sort-Object

        $SelectedLabel.Content = "Selected Apps: $($sync.SelectedApps.Count)"
        $SelectedLabel.ToolTip = $sync.SelectedApps -join "`n"
    }
    elseif ($type -eq "Remove") {
        $sync.SelectedApps.Remove($app_name)
        $SelectedLabel.Content = "Selected Apps: $($sync.SelectedApps.Count)"
        $selected = $sync.selectedApps -join "`n"

        if ($selected -ne "") {
            $SelectedLabel.ToolTip = $sync.SelectedApps -join "`n"
        } else {
            $SelectedLabel.ToolTip = $Null
        }

    }
    else{
        Write-Error "Type: $type not implemented"
    }
}
