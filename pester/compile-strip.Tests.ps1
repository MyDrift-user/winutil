#===========================================================================
# Tests - Compile.ps1 -StripComments
#===========================================================================

BeforeAll {
    $script:repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

    # Compile.ps1 runs a build when dot-sourced, so the function is lifted out of it instead
    $compileText = Get-Content -Path (Join-Path $script:repoRoot "Compile.ps1") -Raw
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($compileText, [ref]$null, [ref]$null)
    $definition = $ast.Find({
        param($node)
        $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
        $node.Name -eq 'Remove-WinUtilComment'
    }, $true)
    . ([scriptblock]::Create($definition.Extent.Text))
}

Describe "Remove-WinUtilComment" {
    It "removes line comments and comment-based help" {
        $stripped = Remove-WinUtilComment -Text @'
function Test-Thing {
    <#
        .SYNOPSIS
            Does a thing
    #>
    # a line comment
    $value = 1
    return $value
}
'@
        $stripped | Should -Not -Match '\.SYNOPSIS'
        $stripped | Should -Not -Match 'a line comment'
        $stripped | Should -Match '\$value = 1'
    }

    It "leaves a # that is inside a string alone" {
        # matching on text rather than tokens would cut the colour out of the middle of this
        $stripped = Remove-WinUtilComment -Text '$colour = "#FF00FF" # the real comment'

        $stripped | Should -Match '#FF00FF'
        $stripped | Should -Not -Match 'the real comment'
    }

    It "keeps a here-string body byte for byte, blank lines and all" {
        $source = @'
$sql = @"
SELECT 1

-- not a PowerShell comment
# neither is this
"@
'@
        $stripped = Remove-WinUtilComment -Text $source

        # compared as text rather than with anchors, since $ does not match before a CR
        $body = [regex]::Match($stripped, '(?s)@"(.*?)"@').Groups[1].Value
        $original = [regex]::Match($source, '(?s)@"(.*?)"@').Groups[1].Value

        $body | Should -BeExactly $original
        $body | Should -Match '# neither is this'
        # the blank line inside the here-string is content, not layout
        $body | Should -Match 'SELECT 1\r?\n\r?\n-- not a PowerShell comment'
    }

    It "produces source that still parses" {
        $original = Get-Content -Path (Join-Path $script:repoRoot "functions\private\Invoke-WinUtilAssets.ps1") -Raw
        $stripped = Remove-WinUtilComment -Text $original

        $parseErrors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseInput($stripped, [ref]$null, [ref]$parseErrors)
        $parseErrors | Should -BeNullOrEmpty
        $stripped.Length | Should -BeLessThan $original.Length
    }

    It "defines the same functions it started with" {
        $original = Get-Content -Path (Join-Path $script:repoRoot "functions\private\Invoke-WinUtilAssets.ps1") -Raw
        $stripped = Remove-WinUtilComment -Text $original

        $names = {
            param($text)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($text, [ref]$null, [ref]$null)
            @($ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true) |
                ForEach-Object { $_.Name }) -join ','
        }

        (& $names $stripped) | Should -Be (& $names $original)
    }

    It "refuses source that does not parse rather than mangling it" {
        { Remove-WinUtilComment -Text 'function Broken {' } | Should -Throw
    }
}
