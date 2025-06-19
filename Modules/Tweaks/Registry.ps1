function Invoke-WinutilRegistryTweak {
    <#
    .SYNOPSIS
    Applies or undoes registry tweaks
    
    .PARAMETER Tweak
    Tweak object from tweaks.json containing registry entries
    
    .PARAMETER Undo
    Whether to undo the tweak (restore original values)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Tweak,
        
        [Parameter(Mandatory=$false)]
        [bool]$Undo = $false
    )
    
    try {
        $action = if ($Undo) { "Undoing" } else { "Applying" }
        Write-Log "$action registry tweak: $($Tweak.Content)" -Level "DEBUG"
        
        if (-not $Tweak.registry) {
            Write-Log "No registry entries found for tweak: $($Tweak.Content)" -Level "WARN"
            return $true
        }
        
        $success = $true
        foreach ($regEntry in $Tweak.registry) {
            try {
                $path = $regEntry.Path
                $name = $regEntry.Name
                $type = $regEntry.Type
                
                # Determine value to set
                $value = if ($Undo) { $regEntry.OriginalValue } else { $regEntry.Value }
                
                # Ensure the registry path exists
                if (-not (Test-Path $path)) {
                    Write-Log "Creating registry path: $path" -Level "DEBUG"
                    New-Item -Path $path -Force | Out-Null
                }
                
                # Handle special cases
                if ($value -eq "<RemoveEntry>") {
                    # Remove the registry entry
                    if (Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue) {
                        Write-Log "Removing registry entry: $path\$name" -Level "DEBUG"
                        Remove-ItemProperty -Path $path -Name $name -Force
                    }
                } else {
                    # Set the registry value
                    Write-Log "Setting registry: $path\$name = $value ($type)" -Level "DEBUG"
                    Set-ItemProperty -Path $path -Name $name -Value $value -Type $type -Force
                }
            }
            catch {
                Write-Log "Failed to process registry entry $($regEntry.Path)\$($regEntry.Name): $($_.Exception.Message)" -Level "ERROR"
                $success = $false
            }
        }
        
        return $success
    }
    catch {
        Write-Log "Exception in Invoke-RegistryTweak for $($Tweak.Content): $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-RegistryTweak 