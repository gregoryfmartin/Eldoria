using namespace System

Set-StrictMode -Version Latest

BeforeAll {
    . "$PSScriptRoot\..\Classes\ATStrings\ATString.ps1"
    . "$PSScriptRoot\..\Classes\ATStrings\ATStringPrefix.ps1"
    . "$PSScriptRoot\..\Classes\ATStrings\ATStringPrefixNone.ps1"
    . "$PSScriptRoot\..\Classes\UI\UIEBase.ps1"
}

Describe 'UIEBase' {
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
            # $uie.Prefix | Should -BeOfType [ATStringPrefixNone]
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
            $uie = [UIEBase]::new()
            $uie.SetUserData("")
            $uie.UserData | Should -Be ""
            $uie.Blank.Length | Should -Be 1
        }

        It 'Should handle null user data' {
            $uie = [UIEBase]::new()
            $uie.SetUserData($null)
            $uie.UserData | Should -Be ""
            $uie.Blank.Length | Should -Be 1
        }
    }

    Context 'SetBlankSize' {
        It 'Should set blank size correctly' {
            $uie = [UIEBase]::new()
            $uie.SetBlankSize(5)
            $uie.Blank.Length | Should -Be 5
            $uie.Blank | Should -Be '     '
        }

        It 'Should handle zero or negative size' {
            $uie = [UIEBase]::new()
            $uie.SetBlankSize(0)
            $uie.Blank | Should -Be ' '
            $uie.SetBlankSize(-1)
            $uie.Blank | Should -Be ' '
        }
    }

    Context 'ToAnsiControlSequenceString' {
        It 'Should generate correct ANSI control sequence string' {
            $uie = [UIEBase]::new()
            $uie.SetUserData("Test")
            # The exact string comparison will depend on your ATString implementation
            # This just verifies it contains the blank space and the user data
            $result = $uie.ToAnsiControlSequenceString()
            $result | Should -Match '    '  # Blank space
            $result | Should -Match 'Test'  # User data
        }
    }

    Context 'Draw' {
        It 'Should reset dirty flag after drawing' {
            $uie = [UIEBase]::new()
            $uie.Dirty = $true
            $uie.Draw()
            $uie.Dirty | Should -Be $false
        }

        It 'Should not draw if not dirty' {
            $uie = [UIEBase]::new()
            $uie.Dirty = $false
            # Mock Write-Host to verify it's not called
            Mock Write-Host {} -Verifiable
            $uie.Draw()
            Should -Not -Invoke Write-Host
        }
    }
}
