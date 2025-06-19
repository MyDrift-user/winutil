function Invoke-WinutilTweakAction {
    <#
    .SYNOPSIS
    Dispatcher for tweak apply/undo actions
    
    .PARAMETER TweakID
    ID of the tweak from tweaks.json
    
    .PARAMETER Action
    Action to perform: 'Apply' or 'Undo'
    
    .PARAMETER Config
    Configuration object containing tweaks
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$TweakID,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('Apply', 'Undo')]
        [string]$Action,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Config
    )
    
    try {
        # Look up tweak in configuration
        if (-not $Config.PSObject.Properties.Name -contains $TweakID) {
            Write-Log "Tweak ID '$TweakID' not found in configuration" -Level "ERROR"
            return $false
        }
        
        $tweak = $Config.$TweakID
        $undo = $Action -eq "Undo"
        
        Write-Log "Processing $Action for tweak: $($tweak.Content)" -Level "DEBUG"
        
        $success = $true
        
        # Process registry tweaks
        if ($tweak.registry) {
            Write-Log "Processing registry entries for tweak: $($tweak.Content)" -Level "DEBUG"
            if (-not (Invoke-WinutilRegistryTweak -Tweak $tweak -Undo $undo)) {
                $success = $false
            }
        }
        
        # Process service tweaks
        if ($tweak.service) {
            Write-Log "Processing service entries for tweak: $($tweak.Content)" -Level "DEBUG"
            if (-not (Invoke-WinutilServiceTweak -Tweak $tweak -Undo $undo)) {
                $success = $false
            }
        }
        
        # Process script tweaks
        if (($tweak.InvokeScript -and -not $undo) -or ($tweak.UndoScript -and $undo)) {
            Write-Log "Processing script entries for tweak: $($tweak.Content)" -Level "DEBUG"
            if (-not (Invoke-WinutilScriptTweak -Tweak $tweak -Undo $undo)) {
                $success = $false
            }
        }
        
        if ($success) {
            Write-Log "Successfully completed $Action for tweak: $($tweak.Content)" -Level "DEBUG"
        } else {
            Write-Log "Some operations failed for $Action of tweak: $($tweak.Content)" -Level "WARN"
        }
        
        return $success
    }
    catch {
        Write-Log "Exception in Invoke-WinutilTweakAction for $TweakID`: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-WinutilTweakAction 