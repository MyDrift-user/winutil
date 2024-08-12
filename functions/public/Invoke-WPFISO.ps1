function Get-RegistryValue($path, $name) {
    $key = Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue
    return $key.$name
}

# Begin
$OS_VERSION = Get-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" "CurrentBuildNumber"
$OS_VID = Get-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" "DisplayVersion"
$OS_EDITION = Get-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" "EditionID"
$OS_PRODUCT = Get-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" "ProductName"
$OS_LANGCODE = Get-RegistryValue "HKU\S-1-5-18\Control Panel\Desktop\MuiCached" "MachinePreferredUILanguages"

# In PowerShell, the $OS_LANGCODE variable might return an array. To handle it:
if ($OS_LANGCODE -is [System.Array]) {
    $OS_LANGCODE = $OS_LANGCODE[0]
}

$OS_ARCH = "x64"
if ($env:PROCESSOR_ARCHITECTURE.EndsWith("86") -and (-not $env:PROCESSOR_ARCHITEW6432)) {
    $OS_ARCH = "x86"
}

# To print the results (optional)
Write-Output "OS Version: $OS_VERSION"
Write-Output "OS VID: $OS_VID"
Write-Output "OS Edition: $OS_EDITION"
Write-Output "OS Product: $OS_PRODUCT"
Write-Output "OS Language Code: $OS_LANGCODE"
Write-Output "OS Architecture: $OS_ARCH"

# Populate ComboBox with versions
foreach ($item in $sync.confics.winver) {
    $comboBoxItem = New-Object System.Windows.Controls.ComboBoxItem
    $comboBoxItem.Content = $item.version
    $winVersionDropdown.Items.Add($comboBoxItem)
}
