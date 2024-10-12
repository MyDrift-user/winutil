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
        $sync.selectedApps.Add($($sync.configs.applications | Where-Object { $_.Name -eq $app_name }))
        # The List type needs to be specified again, because otherwise Sort-Object will convert the list to a string if there is only a single entry
        [System.Collections.Generic.List[pscustomobject]]$sync.selectedApps = $sync.SelectedApps | Sort-Object
    }
    elseif ($type -eq "Remove") {
        $appToRemove = $sync.SelectedApps | Where-Object { $_.name -eq $app_name }
        if ($appToRemove) {
            $sync.SelectedApps.Remove($appToRemove)
        }
    }
    else{
        Write-Error "Type: $type not implemented"
    }
    $count = $sync.SelectedApps.Count
    $SelectedLabel.Content = "Selected Apps: $count"
    if ($count -gt 0) {
        $SelectedLabel.ToolTip = $($sync.SelectedApps | Select-Object -ExpandProperty name) -join "`n"
    } else {
        $SelectedLabel.ToolTip = $Null
    }
}
