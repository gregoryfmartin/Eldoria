# This assumes your test runner can locate and load these class files.
# If running this file directly, you would need to dot-source all dependencies.
# e.g., . (Join-Path $PSScriptRoot '..\..\..\Classes\ATStrings\ATControlSequences.ps1')
#      . (Join-Path $PSScriptRoot '..\..\..\Classes\Console\ConsoleColor24.ps1')
#      . (Join-Path $PSScriptRoot '..\..\..\Classes\ATStrings\ATCoordinates.ps1')
#      ... and so on for all related ATString classes.

Describe 'ATSceneImageString Class' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATDecoration.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATCoordinates.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATBackgroundColor.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATForegroundColor.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATDecorationNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATCoordinatesNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATBackgroundColorNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATForegroundColorNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATStringPrefix.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATStringPrefixNone.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATString.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATSceneImageString.ps1

        $script:TestColor   = [ConsoleColor24]::new(255, 10, 20)
        $script:TestBgColor = [ATBackgroundColor24]::new($script:TestColor)
        $script:TestCoords  = [ATCoordinates]::new(5, 15)
    }

    Context 'Constructor' {
        It 'should initialize all properties correctly' {
            $imageString = [ATSceneImageString]::new($script:TestBgColor, $script:TestCoords)

            # Verify the properties of the aggregated Prefix object
            $imageString.Prefix.BackgroundColor | Should -BeSameAs $script:TestBgColor
            $imageString.Prefix.Coordinates     | Should -BeSameAs $script:TestCoords
            $imageString.Prefix.ForegroundColor | Should -BeOfType ([ATForegroundColor24None])
            $imageString.Prefix.Decorations     | Should -BeOfType ([ATDecorationNone])

            # Verify the properties of the base ATString class
            $imageString.UserData   | Should -Be ' '
            $imageString.UseATReset | Should -Be $true
        }
    }

    Context 'ToAnsiControlSequenceString Method' {
        It 'should return the correct combined ANSI string' {
            $imageString = [ATSceneImageString]::new($script:TestBgColor, $script:TestCoords)

            # Manually build the expected string based on the components.
            # This tests the integration of the components set in the constructor.
            $expectedCoords      = $script:TestCoords.ToAnsiControlSequenceString()         # e.g., `e[5;15H
            $expectedDecorations = '' # From ATDecorationNone
            $expectedFgColor     = ''     # From ATForegroundColor24None
            $expectedBgColor     = $script:TestBgColor.ToAnsiControlSequenceString()       # e.g., `e[48;2;255;10;20m
            $expectedUserData    = ' '
            $expectedReset       = [ATControlSequences]::ModifierReset                       # e.g., `e[0m

            # The final string is an assembly of the prefix, user data, and reset code.
            $expectedString = "$expectedCoords$expectedDecorations$expectedFgColor$expectedBgColor$expectedUserData$expectedReset"

            $imageString.ToAnsiControlSequenceString() | Should -Be $expectedString
        }
    }
}

