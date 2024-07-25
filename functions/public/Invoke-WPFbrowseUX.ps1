function Invoke-WPFbrowseUX {
    <#

    .SYNOPSIS
        installs security extensions for browsers
    #>

    # Define the registry key path for URL associations
    $urlAssociationKeyPath = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice"

    # Get the ProgId of the default browser for HTTP protocol
    try {
        $defaultBrowserProgId = (Get-ItemProperty -Path $urlAssociationKeyPath -Name ProgId).ProgId
        Write-host $defaultBrowserProgId
    } catch {
        Write-Output "Could not retrieve default browser ProgId."
        exit
    }


}