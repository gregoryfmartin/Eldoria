Describe 'ATControlSequences' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
    }

    Context 'Static Methods' {
        It 'GenerateFG24String should return the correct ANSI sequence for a foreground color' {
            [ConsoleColor24]$TestColor = [ConsoleColor24]::new(10, 20, 30)
            [String]$ExpectedString    = "`e[38;2;10;20;30m"

            [String]$Result = [ATControlSequences]::GenerateFG24String($TestColor)

            $Result | Should -Be $ExpectedString
        }

        It 'GenerateBG24String should return the correct ANSI sequence for a background color' {
            [ConsoleColor24]$TestColor = [ConsoleColor24]::new(101, 102, 103)
            [String]$ExpectedString    = "`e[48;2;101;102;103m"

            [String]$Result = [ATControlSequences]::GenerateBG24String($TestColor)

            $Result | Should -Be $ExpectedString
        }

        It 'GenerateCoordinateString should return the correct ANSI sequence for cursor position' {
            [Int]$TestRow           = 5
            [Int]$TestColumn        = 80
            [String]$ExpectedString = "`e[5;80H"

            [String]$Result = [ATControlSequences]::GenerateCoordinateString($TestRow, $TestColumn)

            $Result | Should -Be $ExpectedString
        }
    }

    Context 'Static Properties' {
        It 'Should have the correct value for ForegroundColor24Prefix' {
            [ATControlSequences]::ForegroundColor24Prefix | Should -Be "`e[38;2;"
        }

        It 'Should have the correct value for BackgroundColor24Prefix' {
            [ATControlSequences]::BackgroundColor24Prefix | Should -Be "`e[48;2;"
        }

        It 'Should have the correct value for DecorationBlink' {
            [ATControlSequences]::DecorationBlink | Should -Be "`e[5m"
        }

        It 'Should have the correct value for DecorationItalic' {
            [ATControlSequences]::DecorationItalic | Should -Be "`e[3m"
        }

        It 'Should have the correct value for DecorationUnderline' {
            [ATControlSequences]::DecorationUnderline | Should -Be "`e[4m"
        }

        It 'Should have the correct value for DecorationStrikethru' {
            [ATControlSequences]::DecorationStrikethru | Should -Be "`e[9m"
        }

        It 'Should have the correct value for ModifierReset' {
            [ATControlSequences]::ModifierReset | Should -Be "`e[0m"
        }
    }
}


