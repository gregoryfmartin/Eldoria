using namespace System

Set-StrictMode -Version Latest

Describe 'UIEMenuItem' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCBlack.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVGreenLight.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVGreyDark.ps1
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
        . $PSScriptRoot\..\Classes\UI\Controls\UIEMenuItem.ps1
    }

    Context 'Initialization' {
        It 'Should initialize with default values' {
            $MenuItem = [UIEMenuItem]::new()

            $MenuItem.PSTypeNames | Should -Contain 'UIEMenuItem'
            $MenuItem.Selected | Should -BeFalse
            $MenuItem.Action.Ast.EndBlock.Statements.Count | Should -Be 0
        }
    }

    Context 'ToggleSelected Method' {
        It 'Should toggle the Selected property' {
            $MenuItem = [UIEMenuItem]::new()

            $MenuItem.Selected | Should -BeFalse
            $MenuItem.ToggleSelected()
            $MenuItem.Selected | Should -BeTrue
            $MenuItem.ToggleSelected()
            $MenuItem.Selected | Should -BeFalse
        }
    }

    Context 'Update Method' {
        It 'Should update prefix color and user data based on selection state' {
            $MenuItem = [UIEMenuItem]::new()
            $MenuItem.SetUserData('Test Item')

            $MenuItem.ToggleSelected() # CALLS UPDATE
            $MenuItem.Selected | Should -BeTrue
            $MenuItem.UserData | Should -Be '❱ Test Item'
            $MenuItem.Prefix.ForegroundColor.Color.PSTypeNames | Should -Contain 'CCAppleVGreenLight24'
            
            $MenuItem.ToggleSelected() # CALLS UPDATE
            $MenuItem.Selected | Should -BeFalse
            $MenuItem.UserData | Should -Be 'Test Item'
            $MenuItem.Prefix.ForegroundColor.Color.PSTypeNames | Should -Contain 'CCAppleVGreyDark24'
        }
    }

    Context 'ToAnsiControlSequenceString Method' {
        It 'Should return a string from base class implementation' {
            $MenuItem = [UIEMenuItem]::new()
            $Result = $MenuItem.ToAnsiControlSequenceString()
            
            $Result | Should -BeOfType [String]
            
            # AT THIS POINT, SELECTED SHOULD BE FALSE, SO THE STRING SHOULDN'T CONTAIN A CHEVRON
            $MenuItem.Selected | Should -BeFalse
            $Result | Should -Not -Match "$([UIEMenuItem]::ChevronData) "
        }
    }
}
