function Invoke-WinutilScriptTweak {
    <#
    .SYNOPSIS
    Applies or undoes script tweaks
    
    .PARAMETER Tweak
    Tweak object from tweaks.json containing script commands
    
    .PARAMETER Undo
    Whether to undo the tweak (run undo scripts)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Tweak,
        
        [Parameter(Mandatory=$false)]
        [bool]$Undo = $false
    )
    
    try {
        $action = if ($Undo) { "Undoing" } else { "Applying" }
        Write-Log "$action script tweak: $($Tweak.Content)" -Level "DEBUG"
        
        $scripts = if ($Undo) { $Tweak.UndoScript } else { $Tweak.InvokeScript }
        
        if (-not $scripts -or $scripts.Count -eq 0) {
            $scriptType = if ($Undo) { "undo" } else { "invoke" }
            Write-Log "No $scriptType scripts found for tweak: $($Tweak.Content)" -Level "WARN"
            return $true
        }
        
        $success = $true
        for ($i = 0; $i -lt $scripts.Count; $i++) {
            try {
                $script = $scripts[$i]
                Write-Log "Executing script $($i + 1)/$($scripts.Count) for tweak: $($Tweak.Content)" -Level "DEBUG"
                
                # Execute the script
                $result = Invoke-Expression $script
                
                # Check if there was an error in the script execution
                if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
                    Write-Log "Script execution returned exit code: $LASTEXITCODE" -Level "WARN"
                }
                
                Write-Log "Successfully executed script $($i + 1) for tweak: $($Tweak.Content)" -Level "DEBUG"
            }
            catch {
                Write-Log "Failed to execute script $($i + 1) for tweak $($Tweak.Content): $($_.Exception.Message)" -Level "ERROR"
                $success = $false
            }
        }
        
        return $success
    }
    catch {
        Write-Log "Exception in Invoke-ScriptTweak for $($Tweak.Content): $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-ScriptTweak 