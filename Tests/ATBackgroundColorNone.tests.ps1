Describe 'ATBackgroundColor24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCBlack.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATBackgroundColor.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATBackgroundColorNone.ps1
    }

    Context 'Constructor' {
        It 'Should create an instance and correctly store the color object' {
            [ATBackgroundColor24None]$Sample = [ATBackgroundColor24None]::new()

            $Sample.PSTypeNames | Should -Contain 'ATBackgroundColor24None'
        }
    }

    Context 'ToAnsiControlSequenceString Method' {
        It 'Should return the exact string providing the color information' {
            [ATBackgroundColor24None]$Sample = [ATBackgroundColor24None]::new()
            [String]$ExpectedString      = ''

            $Sample.ToAnsiControlSequenceString() | Should -Be $ExpectedString
        }
    }
}

