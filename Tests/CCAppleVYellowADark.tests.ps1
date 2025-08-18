Describe 'CCAppleVYellowADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVYellowADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVYellowADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVYellowADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVYellowADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 212
            $Sample.Blue | Should -Be 38
        }
    }
}