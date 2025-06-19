function Start-Runspace {
    <#
    .SYNOPSIS
    Starts a runspace to execute a scriptblock in parallel
    
    .PARAMETER ScriptBlock
    The scriptblock to execute
    
    .PARAMETER Parameters
    Parameters to pass to the scriptblock
    
    .PARAMETER Name
    Optional name for the runspace (for tracking)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [ScriptBlock]$ScriptBlock,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Parameters = @{},
        
        [Parameter(Mandatory=$false)]
        [string]$Name = "Runspace_$(Get-Date -Format 'yyyyMMdd_HHmmss_fff')"
    )
    
    try {
        Write-Log "Starting runspace: $Name" -Level "DEBUG"
        
        # Initialize or reinitialize runspace pool to ensure all functions are available
        if (-not $global:WinUtilRunspacePool -or $global:WinUtilRunspacePool.RunspacePoolStateInfo.State -ne 'Opened') {
            Initialize-RunspacePool
        } else {
            # Check if we need to reinitialize due to new functions
            $currentFunctions = Get-Command -CommandType Function | Where-Object { 
                $_.Name -like "Invoke-Winutil*" -or $_.Name -eq "Write-Log" 
            }
            
            if ($currentFunctions.Count -gt ($global:WinUtilRunspacePoolFunctionCount -or 0)) {
                Write-Log "Detected new functions, reinitializing runspace pool..." -Level "DEBUG"
                if ($global:WinUtilRunspacePool) {
                    $global:WinUtilRunspacePool.Close()
                    $global:WinUtilRunspacePool.Dispose()
                }
                Initialize-RunspacePool
            }
        }
        
        # Create the runspace
        $runspace = [PowerShell]::Create()
        $runspace.RunspacePool = $global:WinUtilRunspacePool
        
        # Add the script block
        $null = $runspace.AddScript($ScriptBlock)
        
        # Add parameters
        foreach ($param in $Parameters.GetEnumerator()) {
            $null = $runspace.AddParameter($param.Key, $param.Value)
        }
        
        # Start the runspace
        $asyncResult = $runspace.BeginInvoke()
        
        # Track the runspace
        $runspaceInfo = @{
            Name = $Name
            Runspace = $runspace
            AsyncResult = $asyncResult
            StartTime = Get-Date
            Status = "Running"
        }
        
        Add-RunspaceToTracker -RunspaceInfo $runspaceInfo
        
        Write-Log "Successfully started runspace: $Name" -Level "DEBUG"
        return $runspaceInfo
    }
    catch {
        Write-Log "Failed to start runspace '$Name': $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

function Initialize-RunspacePool {
    <#
    .SYNOPSIS
    Initializes the global runspace pool
    
    .PARAMETER MinRunspaces
    Minimum number of runspaces to maintain
    
    .PARAMETER MaxRunspaces
    Maximum number of runspaces allowed
    #>
    param(
        [Parameter(Mandatory=$false)]
        [int]$MinRunspaces = 1,
        
        [Parameter(Mandatory=$false)]
        [int]$MaxRunspaces = 5
    )
    
    try {
        Write-Log "Initializing runspace pool (Min: $MinRunspaces, Max: $MaxRunspaces)" -Level "DEBUG"
        
        # Create initial session state
        $initialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
        
        # Get all functions that start with "Invoke-Winutil" or "Write-Log" for runspaces
        $allFunctions = Get-Command -CommandType Function | Where-Object { 
            $_.Name -like "Invoke-Winutil*" -or $_.Name -eq "Write-Log" 
        }
        
        Write-Log "Found $($allFunctions.Count) functions to import into runspace pool" -Level "DEBUG"
        
        foreach ($function in $allFunctions) {
            try {
                $functionDefinition = "function $($function.Name) { $($function.Definition) }"
                $sessionStateFunction = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry($function.Name, $functionDefinition)
                $initialSessionState.Commands.Add($sessionStateFunction)
                Write-Log "Added function to runspace pool: $($function.Name)" -Level "DEBUG"
            } catch {
                Write-Log "Failed to add function to runspace pool: $($function.Name) - $($_.Exception.Message)" -Level "WARN"
            }
        }
        
        # Store function count for future reference
        $global:WinUtilRunspacePoolFunctionCount = $allFunctions.Count
        
        # Create the runspace pool
        $global:WinUtilRunspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(
            $MinRunspaces, 
            $MaxRunspaces, 
            $initialSessionState, 
            $Host
        )
        
        $global:WinUtilRunspacePool.Open()
        
        Write-Log "Runspace pool initialized successfully" -Level "DEBUG"
    }
    catch {
        Write-Log "Failed to initialize runspace pool: $($_.Exception.Message)" -Level "ERROR"
        throw
    }
}

function Wait-Runspace {
    <#
    .SYNOPSIS
    Waits for a runspace to complete and returns the result
    
    .PARAMETER RunspaceInfo
    The runspace info object returned from Start-Runspace
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$RunspaceInfo
    )
    
    try {
        Write-Log "Waiting for runspace to complete: $($RunspaceInfo.Name)" -Level "DEBUG"
        
        # Wait for completion
        $result = $RunspaceInfo.Runspace.EndInvoke($RunspaceInfo.AsyncResult)
        
        # Update status
        $RunspaceInfo.Status = "Completed"
        $RunspaceInfo.EndTime = Get-Date
        $RunspaceInfo.Duration = $RunspaceInfo.EndTime - $RunspaceInfo.StartTime
        
        # Check for errors
        if ($RunspaceInfo.Runspace.HadErrors) {
            $errors = $RunspaceInfo.Runspace.Streams.Error.ReadAll()
            Write-Log "Runspace '$($RunspaceInfo.Name)' completed with errors: $($errors -join '; ')" -Level "ERROR"
            $RunspaceInfo.Errors = $errors
        } else {
            Write-Log "Runspace '$($RunspaceInfo.Name)' completed successfully in $($RunspaceInfo.Duration.TotalSeconds) seconds" -Level "DEBUG"
        }
        
        # Clean up
        $RunspaceInfo.Runspace.Dispose()
        Remove-RunspaceFromTracker -Name $RunspaceInfo.Name
        
        return $result
    }
    catch {
        Write-Log "Error waiting for runspace '$($RunspaceInfo.Name)': $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

# Functions exported: Start-Runspace, Initialize-RunspacePool, Wait-Runspace 