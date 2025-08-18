Describe 'ATBackgroundColor24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATBackgroundColor.ps1
    }

    Context 'Constructor' {
        It 'Should create an instance and correctly store the color object' {
            [ATBackgroundColor24]$Sample = [ATBackgroundColor24]::new([ConsoleColor24]::new(255, 255, 255))

            $Sample.PSTypeNames | Should -Contain 'ATBackgroundColor24'
        }
    }

    Context 'ToAnsiControlSequenceString Method' {
        It 'Should return the exact string providing the color information' {
            [ATBackgroundColor24]$Sample = [ATBackgroundColor24]::new([ConsoleColor24]::new(255, 255, 255))
            [String]$ExpectedString      = "`e[48;2;255;255;255m"

            $Sample.ToAnsiControlSequenceString() | Should -Be $ExpectedString
        }
    }
}

