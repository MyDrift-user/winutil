#===========================================================================
# Tests - WinGet refuses user scope packages from an elevated process
#===========================================================================

BeforeAll {
    $script:repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

    . (Join-Path $script:repoRoot "functions\private\Install-WinUtilProgramWinget.ps1")

    function Write-WinUtilLog { param($Message, $Level, $Component) }
    function Invoke-WinUtilUnelevated { param([string]$FilePath, [string[]]$ArgumentList, [int]$TimeoutSeconds) }
}

Describe "Install-WinUtilProgramWinget user scope handling" {
    BeforeEach {
        Mock Write-WinUtilLog { }
    }

    It "retries as the signed in user when WinGet refuses a user scope package" {
        # -1978335107 is APPINSTALLER_CLI_ERROR_ADMIN_CONTEXT_ACTION_PROHIBITED
        Mock Start-Process { [pscustomobject]@{ ExitCode = -1978335107 } }
        Mock Invoke-WinUtilUnelevated { [pscustomobject]@{ ExitCode = 0; Output = ""; TimedOut = $false } }

        Install-WinUtilProgramWinget -Action Uninstall -Programs @("MullvadVPN.MullvadBrowser")

        Should -Invoke -CommandName Invoke-WinUtilUnelevated -Times 1 -Exactly -ParameterFilter {
            $FilePath -eq "winget" -and ($ArgumentList -join " ") -like "*uninstall*MullvadVPN.MullvadBrowser*"
        }
    }

    It "reports the retry's exit code rather than the refusal" {
        Mock Start-Process { [pscustomobject]@{ ExitCode = -1978335107 } }
        Mock Invoke-WinUtilUnelevated { [pscustomobject]@{ ExitCode = 0; Output = ""; TimedOut = $false } }

        Install-WinUtilProgramWinget -Action Uninstall -Programs @("MullvadVPN.MullvadBrowser")

        Should -Invoke -CommandName Write-WinUtilLog -ParameterFilter {
            $Message -like "*completed*exit code: 0*"
        }
    }

    It "leaves every other result alone" {
        Mock Start-Process { [pscustomobject]@{ ExitCode = 0 } }
        Mock Invoke-WinUtilUnelevated { [pscustomobject]@{ ExitCode = 0; Output = ""; TimedOut = $false } }

        Install-WinUtilProgramWinget -Action Uninstall -Programs @("Some.Package")

        Should -Invoke -CommandName Invoke-WinUtilUnelevated -Times 0 -Exactly
    }

    It "does not retry an install failure that has nothing to do with scope" {
        Mock Start-Process { [pscustomobject]@{ ExitCode = -1978335212 } }
        Mock Invoke-WinUtilUnelevated { [pscustomobject]@{ ExitCode = 0; Output = ""; TimedOut = $false } }

        Install-WinUtilProgramWinget -Action Install -Programs @("Some.Package")

        Should -Invoke -CommandName Invoke-WinUtilUnelevated -Times 0 -Exactly
    }
}
