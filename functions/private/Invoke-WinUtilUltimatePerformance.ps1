
Function Invoke-WinUtilUltimatePerformance {
    <#

    .SYNOPSIS
        Creates & enables or removes the Ultimate Performance power scheme

    .PARAMETER State
        Indicates whether to enable or disable the Ultimate Performance power scheme

    #>
    param($State)
    Try {
        # Check if Ultimate Performance plan is installed
        $ultimatePlan = powercfg -list | Select-String -Pattern "Ultimate Performance"
    
        if ($state) {
            # If $state is false, uninstall the Ultimate Performance plan
            if ($ultimatePlan) {
                # Extract the GUID of the Ultimate Performance plan
                $ultimatePlanGUID = $ultimatePlan.Line.Split()[3]
    
                # Set a different power plan as active before deleting the Ultimate Performance plan
                $balancedPlan = powercfg -list | Select-String -Pattern "Balanced"
                if ($balancedPlan) {
                    $balancedPlanGUID = $balancedPlan.Line.Split()[3]
                    powercfg -setactive $balancedPlanGUID
    
                    # Delete the Ultimate Performance plan
                    powercfg -delete $ultimatePlanGUID
    
                    Write-Host "Ultimate Performance plan has been uninstalled."
                    Write-Host "> Balanced plan is now active."
                } else {
                    Write-Host "Balanced plan not found. Cannot switch power plans."
                }
            } else {
                Write-Host "Ultimate Performance plan is not installed."
            }
        } else {
            # If $state is true, ensure the Ultimate Performance plan is installed and set it as active
            if ($ultimatePlan) {
                Write-Host "Ultimate Performance plan is already installed."
            } else {
                Write-Host "Installing Ultimate Performance plan..."
                powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
                Start-Sleep -Seconds 2 # Wait a moment for the plan to be created
                Write-Host "> Ultimate Performance plan installed."
            }
    
            # Set the Ultimate Performance plan as active
            $ultimatePlan = powercfg -list | Select-String -Pattern "Ultimate Performance"
            if ($ultimatePlan) {
                $ultimatePlanGUID = $ultimatePlan.Line.Split()[3]
                powercfg -setactive $ultimatePlanGUID
                Write-Host "Ultimate Performance plan is now active."
            } else {
                Write-Host "Failed to find the Ultimate Performance plan after installation."
            }
        }
    } Catch {
        Write-Warning $_.Exception.Message
    }
    
    
}