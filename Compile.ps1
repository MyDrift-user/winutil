param (
    [switch]$Debug,
    [switch]$Run
)
$OFS = "`r`n"
$scriptname = "winutil.ps1"

# Variable to sync between runspaces
$sync = [Hashtable]::Synchronized(@{})
$sync.PSScriptRoot = $PSScriptRoot
$sync.configs = @{}

$header = @"
################################################################################################################
###                                                                                                          ###
### WARNING: This file is automatically generated DO NOT modify this file directly as it will be overwritten ###
###                                                                                                          ###
################################################################################################################
"@

# Create the script in memory.
$script_content = [System.Collections.Generic.List[string]]::new()

Write-Progress -Activity "Compiling" -Status "Adding: Header" -PercentComplete 5
$script_content.Add($header)

Write-Progress -Activity "Compiling" -Status "Adding: Version" -PercentComplete 10
$script_content.Add($(Get-Content .\scripts\start.ps1).replace('#{replaceme}',"$(Get-Date -Format yy.MM.dd)"))

Write-Progress -Activity "Compiling" -Status "Adding: Functions" -PercentComplete 20
Get-ChildItem .\functions -Recurse -File | ForEach-Object {
    $script_content.Add($(Get-Content $psitem.FullName))
    }
Write-Progress -Activity "Compiling" -Status "Adding: Config *.json" -PercentComplete 40
Get-ChildItem .\config | Where-Object {$psitem.extension -eq ".json"} | ForEach-Object {

    $json = (Get-Content $psitem.FullName).replace("'","''")

    # Replace every XML Special Character so it'll render correctly in final build
    # Only do so if json files has content to be displayed (for example the applications, tweaks, features json files)
    # Some Type Convertion using Casting and Cleaning Up of the convertion result using 'Replace' Method
        $jsonAsObject = $json | convertfrom-json
        $firstLevelJsonList = ([System.String]$jsonAsObject).split('=;') | ForEach-Object {
            $_.Replace('=}','').Replace('@{','').Replace(' ','')
        }

       for ($i = 0; $i -lt $firstLevelJsonList.Count; $i += 1) {
            $firstLevelName = $firstLevelJsonList[$i]
            # Note: Avoid using HTML Entity Codes (for example '&rdquo;' (stands for "Right Double Quotation Mark")), and use HTML decimal/hex codes instead.
	        # as using HTML Entity Codes will result in XML parse Error when running the compiled script.
	    if ($jsonAsObject.$firstLevelName.content -ne $null) {
                $jsonAsObject.$firstLevelName.content = $jsonAsObject.$firstLevelName.content.replace('&','&#38;').replace('“','&#8220;').replace('”','&#8221;').replace("'",'&#39;').replace('<','&#60;').replace('>','&#62;')
                $jsonAsObject.$firstLevelName.content = $jsonAsObject.$firstLevelName.content.replace('&#39;&#39;',"&#39;") # resolves the Double Apostrophe caused by the first replace function in the main loop
            }
            if ($jsonAsObject.$firstLevelName.description -ne $null) {
                $jsonAsObject.$firstLevelName.description = $jsonAsObject.$firstLevelName.description.replace('&','&#38;').replace('“','&#8220;').replace('”','&#8221;').replace("'",'&#39;').replace('<','&#60;').replace('>','&#62;')
                $jsonAsObject.$firstLevelName.description = $jsonAsObject.$firstLevelName.description.replace('&#39;&#39;',"&#39;") # resolves the Double Apostrophe caused by the first replace function in the main loop
	    }
	}
	# The replace at the end is required, as without it the output of converto-json will be somewhat weird for Multiline String
	# Most Notably is the scripts in json files, making it harder for users who want to review these scripts that are found in the final compiled script
        $json = ($jsonAsObject | convertto-json -Depth 3).replace('\r\n',"`r`n")

    $sync.configs.$($psitem.BaseName) = $json | convertfrom-json
    $script_content.Add($(Write-output "`$sync.configs.$($psitem.BaseName) = '$json' `| convertfrom-json" ))
}

$xaml = (Get-Content .\xaml\inputXML.xaml).replace("'","''")

# Dot-source the Get-TabXaml function
. .\functions\private\Get-TabXaml.ps1

Write-Progress -Activity "Compiling" -Status "Building: Xaml " -PercentComplete 75
$appXamlContent = Get-TabXaml "applications" 5
$tweaksXamlContent = Get-TabXaml "tweaks"
$featuresXamlContent = Get-TabXaml "feature"


Write-Progress -Activity "Compiling" -Status "Adding: Xaml " -PercentComplete 90
# Replace the placeholder in $inputXML with the content of inputApp.xaml
$xaml = $xaml -replace "{{InstallPanel_applications}}", $appXamlContent
$xaml = $xaml -replace "{{InstallPanel_tweaks}}", $tweaksXamlContent
$xaml = $xaml -replace "{{InstallPanel_features}}", $featuresXamlContent

$script_content.Add($(Write-output "`$inputXML =  '$xaml'"))

$script_content.Add($(Get-Content .\scripts\main.ps1))

if ($Debug){
    Write-Progress -Activity "Compiling" -Status "Writing debug files" -PercentComplete 95
    $appXamlContent | Out-File -FilePath ".\xaml\inputApp.xaml" -Encoding ascii
    $tweaksXamlContent | Out-File -FilePath ".\xaml\inputTweaks.xaml" -Encoding ascii
    $featuresXamlContent | Out-File -FilePath ".\xaml\inputFeatures.xaml" -Encoding ascii
}
else {
    Write-Progress -Activity "Compiling" -Status "Removing temporary files" -PercentComplete 99
    Remove-Item ".\xaml\inputApp.xaml" -ErrorAction SilentlyContinue
    Remove-Item ".\xaml\inputTweaks.xaml" -ErrorAction SilentlyContinue
    Remove-Item ".\xaml\inputFeatures.xaml" -ErrorAction SilentlyContinue
}

Set-Content -Path $scriptname -Value ($script_content -join "`r`n") -Encoding ascii
Write-Progress -Activity "Compiling" -Completed

if ($run){
    try {
        Start-Process -FilePath "pwsh" -ArgumentList ".\$scriptname"
    }
    catch {
        Start-Process -FilePath "powershell" -ArgumentList ".\$scriptname"
    }
    
}