Describe 'ATForegroundColor24None' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCBlack.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATForegroundColor.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATForegroundColorNone.ps1
    }

    Context 'Constructor' {
        It 'Should create an instance and correctly store the color object' {
            [ATForegroundColor24None]$Sample = [ATForegroundColor24None]::new()

            $Sample.PSTypeNames | Should -Contain 'ATForegroundColor24None'
        }
    }

    Context 'ToAnsiControlSequenceString Method' {
        It 'Should return the exact string providing the color information' {
            [ATForegroundColor24None]$Sample = [ATForegroundColor24None]::new()
            [String]$ExpectedString          = ''

            $Sample.ToAnsiControlSequenceString() | Should -Be $ExpectedString
        }
    }
}

