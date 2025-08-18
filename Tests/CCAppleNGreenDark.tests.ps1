Describe 'CCAppleNGreenDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGreenDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGreenDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGreenDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGreenDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 48
            $Sample.Green | Should -Be 209
            $Sample.Blue | Should -Be 88
        }
    }
}