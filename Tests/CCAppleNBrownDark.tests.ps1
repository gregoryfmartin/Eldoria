Describe 'CCAppleNBrownDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNBrownDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNBrownDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNBrownDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNBrownDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 172
            $Sample.Green | Should -Be 142
            $Sample.Blue | Should -Be 104
        }
    }
}