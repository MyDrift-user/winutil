param (
    [switch]$Run,
    [switch]$StripComments
)

$OFS = "`r`n"

function Remove-WinUtilComment {
    <#
        .SYNOPSIS
            Strips PowerShell comments from source text, leaving strings alone

        .DESCRIPTION
            Comments are for whoever reads the source files, and the compiled script is not read,
            it is run. Dropping them costs the release nothing and saves everyone who fetches it
            about a tenth of the download.

            Tokenises rather than pattern matches, because a # is only a comment outside a string:
            matching on text would cut into a here-string body, a hash literal key or the // in an
            embedded C# block. Lines left holding nothing but the indentation of a removed comment
            are dropped too, except inside a multi-line string, where a blank line is content.

        .PARAMETER Text
            The PowerShell source to strip.
    #>
    param([string]$Text)

    $tokens = $null
    $parseErrors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors) {
        throw "Refusing to strip comments from source that does not parse: $($parseErrors[0].Message)"
    }

    # Lines covered by a multi-line token, where whitespace is data rather than layout
    $protected = New-Object System.Collections.Generic.HashSet[int]
    foreach ($token in $tokens) {
        if ($token.Extent.StartLineNumber -ne $token.Extent.EndLineNumber) {
            for ($line = $token.Extent.StartLineNumber; $line -le $token.Extent.EndLineNumber; $line++) {
                $null = $protected.Add($line)
            }
        }
    }

    $emptied = New-Object System.Collections.Generic.HashSet[int]
    foreach ($token in ($tokens | Where-Object { $_.Kind -eq 'Comment' } | Sort-Object { $_.Extent.StartOffset } -Descending)) {
        $extent = $token.Extent
        if (-not $protected.Contains($extent.StartLineNumber)) {
            for ($line = $extent.StartLineNumber; $line -le $extent.EndLineNumber; $line++) {
                $null = $emptied.Add($line)
            }
        }
        $Text = $Text.Remove($extent.StartOffset, $extent.EndOffset - $extent.StartOffset)
    }

    # Each line is kept with the terminator it came with, so a checkout using LF is not silently
    # rewritten to CRLF inside a here-string, where the bytes are content
    $result = New-Object System.Text.StringBuilder
    $number = 0
    foreach ($match in [regex]::Matches($Text, '[^\r\n]*(?:\r\n|\n|\r)?')) {
        if ($match.Length -eq 0) { continue }
        $number++
        if ($emptied.Contains($number) -and [string]::IsNullOrWhiteSpace($match.Value)) { continue }
        $null = $result.Append($match.Value)
    }
    return $result.ToString()
}

# Variable to sync between runspaces
$sync = [Hashtable]::Synchronized(@{})
$sync.configs = @{}

# Not stripped: the version marker it carries is itself a comment, so removing comments here
# would take the stamp with it
$script = (Get-Content -Path scripts\start.ps1) -replace '#{replaceme}', (Get-Date -Format 'yy.MM.dd')

$script += Get-ChildItem -Path functions -Recurse -File | ForEach-Object {
    $source = Get-Content -Path $_.FullName -Raw
    if ($StripComments) { Remove-WinUtilComment -Text $source } else { $source }
}

Get-ChildItem config | ForEach-Object {
    $obj = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json

    if ($_.Name -eq "applications.json") {
        $fixed = [ordered]@{}
        foreach ($p in $obj.PSObject.Properties) {
            $fixed["WPFInstall$($p.Name)"] = $p.Value
        }
        $obj = [pscustomobject]$fixed
    }

    $json = $obj | ConvertTo-Json -Depth 10

    $sync.configs[$_.BaseName] = $obj
    $script += "`$sync.configs.$($_.BaseName) = @'`r`n$json`r`n'@ | ConvertFrom-Json"
}

$xaml = Get-Content -Path xaml\inputXML.xaml -Raw
$script += "`$inputXML = @'`r`n$xaml`r`n'@"

$autounattendXml = Get-Content -Path tools\autounattend.xml -Raw
$script += "`$WinUtilAutounattendXml = @'`r`n$autounattendXml`r`n'@"

$mainScript = Get-Content -Path scripts\main.ps1 -Raw
if ($StripComments) { $mainScript = Remove-WinUtilComment -Text $mainScript }
$script += $mainScript

Set-Content -Path winutil.ps1 -Value $script

if ($Run) {
    .\Winutil.ps1
}
