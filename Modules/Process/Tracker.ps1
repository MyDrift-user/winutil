function Initialize-RunspaceTracker {
    <#
    .SYNOPSIS
    Initializes the global runspace tracker
    #>
    
    if (-not $global:WinUtilRunspaceTracker) {
        $global:WinUtilRunspaceTracker = [System.Collections.Concurrent.ConcurrentDictionary[string, hashtable]]::new()
        Write-Log "Runspace tracker initialized" -Level "DEBUG"
    }
}

function Add-RunspaceToTracker {
    <#
    .SYNOPSIS
    Adds a runspace to the global tracker
    
    .PARAMETER RunspaceInfo
    The runspace info hashtable to track
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$RunspaceInfo
    )
    
    try {
        Initialize-RunspaceTracker
        
        $global:WinUtilRunspaceTracker.TryAdd($RunspaceInfo.Name, $RunspaceInfo) | Out-Null
        Write-Log "Added runspace to tracker: $($RunspaceInfo.Name)" -Level "DEBUG"
    }
    catch {
        Write-Log "Failed to add runspace to tracker: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Remove-RunspaceFromTracker {
    <#
    .SYNOPSIS
    Removes a runspace from the global tracker
    
    .PARAMETER Name
    Name of the runspace to remove
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    
    try {
        if ($global:WinUtilRunspaceTracker) {
            $removed = $global:WinUtilRunspaceTracker.TryRemove($Name, [ref]$null)
            if ($removed) {
                Write-Log "Removed runspace from tracker: $Name" -Level "DEBUG"
            }
        }
    }
    catch {
        Write-Log "Failed to remove runspace from tracker: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Get-ActiveRunspaces {
    <#
    .SYNOPSIS
    Gets all currently active runspaces
    
    .PARAMETER FilterByStatus
    Optional status filter (Running, Completed, etc.)
    #>
    param(
        [Parameter(Mandatory=$false)]
        [string]$FilterByStatus = $null
    )
    
    try {
        Initialize-RunspaceTracker
        
        $runspaces = @()
        foreach ($entry in $global:WinUtilRunspaceTracker.GetEnumerator()) {
            $runspaceInfo = $entry.Value
            
            # Update status if runspace is complete
            if ($runspaceInfo.Status -eq "Running" -and $runspaceInfo.AsyncResult.IsCompleted) {
                $runspaceInfo.Status = "Completed"
                $runspaceInfo.EndTime = Get-Date
                $runspaceInfo.Duration = $runspaceInfo.EndTime - $runspaceInfo.StartTime
            }
            
            # Apply filter if specified
            if (-not $FilterByStatus -or $runspaceInfo.Status -eq $FilterByStatus) {
                $runspaces += $runspaceInfo
            }
        }
        
        return $runspaces
    }
    catch {
        Write-Log "Failed to get active runspaces: $($_.Exception.Message)" -Level "ERROR"
        return @()
    }
}

function Wait-AllRunspaces {
    <#
    .SYNOPSIS
    Waits for all tracked runspaces to complete
    
    .PARAMETER TimeoutSeconds
    Maximum time to wait in seconds (default: 300)
    #>
    param(
        [Parameter(Mandatory=$false)]
        [int]$TimeoutSeconds = 300
    )
    
    try {
        Write-Log "Waiting for all runspaces to complete (timeout: $TimeoutSeconds seconds)" -Level "DEBUG"
        
        $startTime = Get-Date
        $runningRunspaces = Get-ActiveRunspaces -FilterByStatus "Running"
        
        while ($runningRunspaces.Count -gt 0 -and ((Get-Date) - $startTime).TotalSeconds -lt $TimeoutSeconds) {
            Write-Log "Waiting for $($runningRunspaces.Count) runspaces to complete..." -Level "DEBUG"
            Start-Sleep -Seconds 2
            $runningRunspaces = Get-ActiveRunspaces -FilterByStatus "Running"
        }
        
        if ($runningRunspaces.Count -eq 0) {
            Write-Log "All runspaces completed successfully" -Level "DEBUG"
            return $true
        } else {
            Write-Log "Timeout reached. $($runningRunspaces.Count) runspaces still running" -Level "WARN"
            return $false
        }
    }
    catch {
        Write-Log "Error waiting for runspaces: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

function Stop-AllRunspaces {
    <#
    .SYNOPSIS
    Stops all running runspaces and cleans up the tracker
    #>
    
    try {
        Write-Log "Stopping all runspaces..." -Level "DEBUG"
        
        $runspaces = Get-ActiveRunspaces
        foreach ($runspaceInfo in $runspaces) {
            try {
                if ($runspaceInfo.Status -eq "Running") {
                    Write-Log "Stopping runspace: $($runspaceInfo.Name)" -Level "DEBUG"
                    $runspaceInfo.Runspace.Stop()
                }
                $runspaceInfo.Runspace.Dispose()
            }
            catch {
                Write-Log "Error stopping runspace '$($runspaceInfo.Name)': $($_.Exception.Message)" -Level "ERROR"
            }
        }
        
        # Clear the tracker
        if ($global:WinUtilRunspaceTracker) {
            $global:WinUtilRunspaceTracker.Clear()
        }
        
        # Close the runspace pool
        if ($global:WinUtilRunspacePool) {
            $global:WinUtilRunspacePool.Close()
            $global:WinUtilRunspacePool.Dispose()
            $global:WinUtilRunspacePool = $null
        }
        
        Write-Log "All runspaces stopped and cleaned up" -Level "DEBUG"
    }
    catch {
        Write-Log "Error stopping runspaces: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Test-ExclusiveMode {
    <#
    .SYNOPSIS
    Checks if exclusive mode is active (no other operations should run)
    
    .PARAMETER SetExclusive
    Sets exclusive mode on/off
    #>
    param(
        [Parameter(Mandatory=$false)]
        [bool]$SetExclusive = $null
    )
    
    if ($null -ne $SetExclusive) {
        $global:WinUtilExclusiveMode = $SetExclusive
        $status = if ($SetExclusive) { "enabled" } else { "disabled" }
        Write-Log "Exclusive mode $status" -Level "DEBUG"
    }
    
    return [bool]$global:WinUtilExclusiveMode
}

# Functions exported: Initialize-RunspaceTracker, Add-RunspaceToTracker, Remove-RunspaceFromTracker, Get-ActiveRunspaces, Wait-AllRunspaces, Stop-AllRunspaces, Test-ExclusiveMode 