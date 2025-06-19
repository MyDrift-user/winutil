function Invoke-WinutilUninstallApp {
    <#
    .SYNOPSIS
    Uninstalls an application using winget or chocolatey
    
    .PARAMETER App
    App object from applications.json containing winget/choco IDs
    
    .PARAMETER Method
    Uninstallation method: 'winget' or 'choco'
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$App,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('winget', 'choco')]
        [string]$Method
    )
    
    try {
        Write-Log "Uninstalling $($App.content)..." -Level "INFO"
        
        switch ($Method) {
            'winget' {
                if ($App.winget -and $App.winget -ne "na") {
                    $process = Start-Process -FilePath "winget" -ArgumentList "uninstall", "--id", $App.winget -Wait -PassThru -NoNewWindow
                    if ($process.ExitCode -eq 0) {
                        Write-Log "Successfully uninstalled $($App.content)" -Level "INFO"
                        return $true
                    } else {
                        Write-Log "Failed to uninstall $($App.content) via winget. Exit code: $($process.ExitCode)" -Level "ERROR"
                        return $false
                    }
                } else {
                    Write-Log "No winget ID available for $($App.content)" -Level "WARN"
                    return $false
                }
            }
            
            'choco' {
                if ($App.choco -and $App.choco -ne "na") {
                    $process = Start-Process -FilePath "choco" -ArgumentList "uninstall", $App.choco, "-y" -Wait -PassThru -NoNewWindow
                    if ($process.ExitCode -eq 0) {
                        Write-Log "Successfully uninstalled $($App.content)" -Level "INFO"
                        return $true
                    } else {
                        Write-Log "Failed to uninstall $($App.content) via chocolatey. Exit code: $($process.ExitCode)" -Level "ERROR"
                        return $false
                    }
                } else {
                    Write-Log "No chocolatey ID available for $($App.content)" -Level "WARN"
                    return $false
                }
            }
        }
    }
    catch {
        Write-Log "Exception during uninstallation of $($App.content): $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Uninstall-App 