Function Install-WinUtilProgramWinget {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("Install", "Uninstall")]
        [string]$Action,

        [Parameter(Mandatory=$true)]
        [string[]]$Programs
    )

    foreach ($program in $Programs) {
        if ([string]::IsNullOrWhiteSpace($program) -or $program -eq "na") {
            continue
        }

        $source = "winget"
        if ($program.StartsWith("msstore:", [System.StringComparison]::OrdinalIgnoreCase)) {
            $source = "msstore"
            $program = $program.Substring("msstore:".Length)
        }

        if ($Action -eq 'Install') {
            $arguments = @("install", "--id", $program, "--accept-package-agreements", "--accept-source-agreements", "--source", $source, "--silent")
        } else {
            $arguments = @("uninstall", "--id", $program, "--source", $source, "--silent")
        }

        # APPINSTALLER_CLI_ERROR_ADMIN_CONTEXT_ACTION_PROHIBITED. WinGet will not act on a package
        # that was installed in user scope while it is running elevated, and WinUtil always is,
        # so every per-user app answers this and nothing happens.
        $adminContextProhibited = -1978335107

        Write-WinUtilLog -Component "Package" -Message "$Action winget package: $program (source: $source)"
        $process = Start-Process -FilePath winget -ArgumentList $arguments -NoNewWindow -Wait -PassThru
        $exitCode = $process.ExitCode

        # A process cannot drop its own elevation, so the same command is handed to the signed in
        # user, which is the context WinGet requires for their own packages
        if ($exitCode -eq $adminContextProhibited) {
            Write-WinUtilLog -Component "Package" -Message "$program is installed for the current user, which WinGet will not touch from an elevated process. Retrying as the signed in user."
            $unelevated = Invoke-WinUtilUnelevated -FilePath "winget" -ArgumentList $arguments
            $exitCode = $unelevated.ExitCode

            if ($unelevated.TimedOut) {
                Write-WinUtilLog -Level "WARN" -Component "Package" -Message "$Action $program did not finish as the signed in user."
            }
        }

        Write-WinUtilLog -Component "Package" -Message "$Action winget package completed: $program (exit code: $exitCode)"
    }
}
