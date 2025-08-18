Describe 'CCAppleNGreenADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGreenADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGreenADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGreenADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGreenADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 48
            $Sample.Green | Should -Be 219
            $Sample.Blue | Should -Be 91
        }
    }
}