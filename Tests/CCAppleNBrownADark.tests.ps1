Describe 'CCAppleNBrownADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNBrownADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNBrownADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNBrownADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNBrownADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 181
            $Sample.Green | Should -Be 148
            $Sample.Blue | Should -Be 105
        }
    }
}