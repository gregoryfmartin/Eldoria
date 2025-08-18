Describe 'CCAppleNYellowADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNYellowADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNYellowADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNYellowADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNYellowADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 212
            $Sample.Blue | Should -Be 38
        }
    }
}