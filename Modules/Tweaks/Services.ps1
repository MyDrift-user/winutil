function Invoke-WinutilServiceTweak {
    <#
    .SYNOPSIS
    Applies or undoes service tweaks
    
    .PARAMETER Tweak
    Tweak object from tweaks.json containing service entries
    
    .PARAMETER Undo
    Whether to undo the tweak (restore original startup types)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Tweak,
        
        [Parameter(Mandatory=$false)]
        [bool]$Undo = $false
    )
    
    try {
        $action = if ($Undo) { "Undoing" } else { "Applying" }
        Write-Log "$action service tweak: $($Tweak.Content)" -Level "DEBUG"
        
        if (-not $Tweak.service) {
            Write-Log "No service entries found for tweak: $($Tweak.Content)" -Level "WARN"
            return $true
        }
        
        $success = $true
        foreach ($serviceEntry in $Tweak.service) {
            try {
                $serviceName = $serviceEntry.Name
                $startupType = if ($Undo) { $serviceEntry.OriginalType } else { $serviceEntry.StartupType }
                
                # Check if service exists
                $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
                if (-not $service) {
                    Write-Log "Service '$serviceName' not found, skipping" -Level "WARN"
                    continue
                }
                
                Write-Log "Setting service '$serviceName' startup type to '$startupType'" -Level "DEBUG"
                
                # Stop service if it's running and we're disabling it
                if ($startupType -eq "Disabled" -and $service.Status -eq "Running") {
                    Write-Log "Stopping service '$serviceName' before disabling" -Level "DEBUG"
                    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
                }
                
                # Set the startup type
                Set-Service -Name $serviceName -StartupType $startupType
                
                Write-Log "Successfully set service '$serviceName' to '$startupType'" -Level "DEBUG"
            }
            catch {
                Write-Log "Failed to process service '$($serviceEntry.Name)': $($_.Exception.Message)" -Level "ERROR"
                $success = $false
            }
        }
        
        return $success
    }
    catch {
        Write-Log "Exception in Invoke-ServiceTweak for $($Tweak.Content): $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-ServiceTweak 