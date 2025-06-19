function Write-Log {
    <#
    .SYNOPSIS
    Writes log messages to console and optionally to UI
    
    .PARAMETER Message
    The message to log
    
    .PARAMETER Level
    Log level: INFO, WARN, ERROR, DEBUG
    
    .PARAMETER UITextBox
    Optional UI TextBox to update with log messages
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('INFO', 'WARN', 'ERROR', 'DEBUG')]
        [string]$Level = 'INFO',
        
        [Parameter(Mandatory=$false)]
        $UITextBox = $null
    )
    
    # Check if we should log this level
    $currentLogLevel = if ($global:WinUtilLogLevel) { $global:WinUtilLogLevel } else { 'INFO' }
    $levelPriority = @{
        'ERROR' = 1
        'WARN' = 2
        'INFO' = 3
        'DEBUG' = 4
    }
    
    # Skip if current level is below the configured level
    if ($levelPriority[$Level] -gt $levelPriority[$currentLogLevel]) {
        return
    }
    
    # Create timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Format the log message
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # Write to console with appropriate color
    switch ($Level) {
        'INFO' { 
            Write-Host $logMessage -ForegroundColor Green 
        }
        'WARN' { 
            Write-Host $logMessage -ForegroundColor Yellow 
        }
        'ERROR' { 
            Write-Host $logMessage -ForegroundColor Red 
        }
        'DEBUG' { 
            Write-Host $logMessage -ForegroundColor Cyan 
        }
        default { 
            Write-Host $logMessage 
        }
    }
    
    # Update UI if TextBox is provided
    if ($UITextBox) {
        try {
            # Ensure we're on the UI thread
            $UITextBox.Dispatcher.Invoke([Action]{
                # Append to existing text
                if ($UITextBox.Text) {
                    $UITextBox.Text += "`r`n"
                }
                $UITextBox.Text += $logMessage
                
                # Auto-scroll to bottom
                $UITextBox.ScrollToEnd()
                
                # Limit text length to prevent memory issues (keep last 10000 characters)
                if ($UITextBox.Text.Length -gt 10000) {
                    $UITextBox.Text = $UITextBox.Text.Substring($UITextBox.Text.Length - 8000)
                }
            })
        }
        catch {
            Write-Host "Failed to update UI TextBox: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Also write to debug stream for advanced logging scenarios
    Write-Debug $logMessage
}

function Initialize-Logging {
    <#
    .SYNOPSIS
    Initializes logging with optional file output
    
    .PARAMETER LogFile
    Optional path to log file
    
    .PARAMETER LogLevel
    Minimum log level to capture
    #>
    param(
        [Parameter(Mandatory=$false)]
        [string]$LogFile = $null,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('INFO', 'WARN', 'ERROR', 'DEBUG')]
        [string]$LogLevel = 'INFO'
    )
    
    # Set global logging variables
    $global:WinUtilLogFile = $LogFile
    $global:WinUtilLogLevel = $LogLevel
    
    # Create log file if specified
    if ($LogFile) {
        try {
            $logDir = Split-Path $LogFile -Parent
            if ($logDir -and -not (Test-Path $logDir)) {
                New-Item -ItemType Directory -Path $logDir -Force | Out-Null
            }
            
            # Create or clear the log file
            "WinUtil Log Session Started: $(Get-Date)" | Out-File -FilePath $LogFile -Encoding UTF8
            Write-Log "Logging initialized. Log file: $LogFile" -Level "INFO"
        }
        catch {
            Write-Log "Failed to initialize log file '$LogFile': $($_.Exception.Message)" -Level "ERROR"
        }
    }
}

# Functions exported: Write-Log, Initialize-Logging 