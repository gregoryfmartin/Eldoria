Describe 'CCAppleGreenLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGreenLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGreenLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGreenLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGreenLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 52
            $Sample.Green | Should -Be 199
            $Sample.Blue | Should -Be 89
        }
    }
}