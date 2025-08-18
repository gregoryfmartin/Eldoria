Describe 'CCAppleVYellowALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVYellowALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVYellowALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVYellowALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVYellowALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 146
            $Sample.Green | Should -Be 81
            $Sample.Blue | Should -Be 0
        }
    }
}