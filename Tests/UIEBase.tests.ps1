using namespace System

Set-StrictMode -Version Latest

Describe 'UIEBase' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCBlack.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATForegroundColor.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATForegroundColorNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATBackgroundColor.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATBackgroundColorNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATCoordinates.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATCoordinatesNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATDecoration.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATDecorationNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATStringPrefix.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATStringPrefixNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATString.ps1
        . $PSScriptRoot\..\Classes\UI\UIEBase.ps1
    }

    Context 'Initialization' {                                                                                                              
        It 'Should initialize with default values' {
            $UIE = [UIEBase]::new()

            $UIE.Dirty | Should -Be $false
            $UIE.Blank | Should -Be ' '
            $UIE.UserData | Should -Be ''
            $UIE.UseATReset | Should -Be $false
            $UIE.Prefix.PSTypeNames | Should -Contain 'ATStringPrefixNone'
            $UIE.Prefix.ForegroundColor.PSTypeNames | Should -Contain 'ATForegroundColor24None'
            $UIE.Prefix.BackgroundColor.PSTypeNames | Should -Contain 'ATBackgroundColor24None'
            $UIE.Prefix.Decorations.PSTypeNames | Should -Contain 'ATDecorationNone'
            $UIE.Prefix.Coordinates.PSTypeNames | Should -Contain 'ATCoordinatesNone'
            $UIE.Prefix.Coordinates.Row | Should -Be 0
            $UIE.Prefix.Coordinates.Column | Should -Be 0
        }
    }

    Context 'SetUserData' {
        It 'Should set user data and adjust blank size if needed' {
            $UIE = [UIEBase]::new()

            $UIE.SetUserData("Test")
            $UIE.UserData | Should -Be "Test"
            $UIE.Blank.Length | Should -Be 4
        }

        It 'Should handle empty user data' {
            $UIE = [UIEBase]::new()

            $UIE.SetUserData("")
            $UIE.UserData | Should -Be ""
            $UIE.Blank.Length | Should -Be 1
        }

        It 'Should handle null user data' {
            $UIE = [UIEBase]::new()

            $UIE.SetUserData($null)
            $UIE.UserData | Should -Be ""
            $UIE.Blank.Length | Should -Be 1
        }
    }

    Context 'SetBlankSize' {
        It 'Should set blank size correctly' {
            $UIE = [UIEBase]::new()

            $UIE.SetBlankSize(5)
            $UIE.Blank.Length | Should -Be 5
            $UIE.Blank | Should -Be '     '
        }

        It 'Should handle zero or negative size' {
            $UIE = [UIEBase]::new()

            $UIE.SetBlankSize(0)
            $UIE.Blank | Should -Be ' '

            $UIE.SetBlankSize(-1)
            $UIE.Blank | Should -Be ' '
        }
    }

    Context 'ToAnsiControlSequenceString' {
        It 'Should generate correct ANSI control sequence string' {
            $UIE = [UIEBase]::new()

            $UIE.SetUserData("Test")

            $Result = $UIE.ToAnsiControlSequenceString()

            $Result | Should -Match '    '
            $Result | Should -Match 'Test'
        }
    }

    Context 'Draw' {
        It 'Should reset dirty flag after drawing' {
            Mock Write-Host {} -Verifiable

            $UIE = [UIEBase]::new()

            $UIE.Dirty = $true
            $UIE.Draw()

            $UIE.Dirty | Should -Be $false
        }

        It 'Should not draw if not dirty' {
            Mock Write-Host {} -Verifiable

            $UIE = [UIEBase]::new()

            $UIE.Dirty = $false
            $UIE.Draw()

            Should -Not -Invoke Write-Host
        }
    }
}
