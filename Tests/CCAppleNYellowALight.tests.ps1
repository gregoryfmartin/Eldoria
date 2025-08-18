Describe 'CCAppleNYellowALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNYellowALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNYellowALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNYellowALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNYellowALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 178
            $Sample.Green | Should -Be 80
            $Sample.Blue | Should -Be 0
        }
    }
}