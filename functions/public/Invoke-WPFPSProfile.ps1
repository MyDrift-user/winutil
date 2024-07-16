function Invoke-WPFPSProfile {
    <#

    .SYNOPSIS
        Installs & applies the CTT Powershell Profile
    #>
    Invoke-WPFRunspace -ScriptBlock {
        if (Get-Command "pwsh" -ErrorAction SilentlyContinue) {
            $installcommand = "https://github.com/ChrisTitusTech/powershell-profile/raw/main/setup.ps1"
            if ($PSVersionTable.PSVersion.Major -ge 7) {
                Invoke-RestMethod "$installcommand" | Invoke-Expression
            } else {
                $ButtonType = [System.Windows.MessageBoxButton]::YesNo
                $MessageboxTitle = "Are you sure?"
                $Messageboxbody = ("PowerShell 7 seems to be installed, but not currently used, should It use the Powershell 7 Shell?")
                $MessageIcon = [System.Windows.MessageBoxImage]::Information
            
                $confirm = [System.Windows.MessageBox]::Show($Messageboxbody, $MessageboxTitle, $ButtonType, $MessageIcon)
                if($confirm -eq "No"){return}
                Start-Process "pwsh" -ArgumentList "-NoExit -Command `"$installcommand`"" -Verb RunAs -Wait
            }
        }
    } else {
        write-host "Can't find an installed version of Powershell 7, this script requires PowerShell 7 to be installed." -ForegroundColor Red
    }
}