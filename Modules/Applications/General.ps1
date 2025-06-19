function Invoke-WinutilAppAction {
    <#
    .SYNOPSIS
    Dispatcher for app installation/uninstallation actions
    
    .PARAMETER AppID
    ID of the app from applications.json
    
    .PARAMETER Action
    Action to perform: 'Install' or 'Uninstall'
    
    .PARAMETER Config
    Configuration object containing apps
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$AppID,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('Install', 'Uninstall')]
        [string]$Action,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Config
    )
    
    try {
        # Look up app in configuration
        if (-not $Config.PSObject.Properties.Name -contains $AppID) {
            Write-Log "App ID '$AppID' not found in configuration" -Level "ERROR"
            return $false
        }
        
        $app = $Config.$AppID
        Write-Log "Processing $Action for app: $($app.content)" -Level "DEBUG"
        
        # Determine installation method - prefer winget over choco
        $method = $null
        if ($app.winget -and $app.winget -ne "na") {
            $method = "winget"
        } elseif ($app.choco -and $app.choco -ne "na") {
            $method = "choco"
        } else {
            Write-Log "No valid installation method found for $($app.content)" -Level "ERROR"
            return $false
        }
        
        # Dispatch to appropriate action
        switch ($Action) {
            'Install' {
                return Invoke-WinutilInstallApp -App $app -Method $method
            }
            'Uninstall' {
                return Invoke-WinutilUninstallApp -App $app -Method $method
            }
        }
    }
    catch {
        Write-Log "Exception in Invoke-WinutilAppAction for $AppID`: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-WinutilAppAction 