Describe 'CCAppleGrey4Light24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGrey4Light.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey4Light24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey4Light24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey4Light24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 209
            $Sample.Green | Should -Be 209
            $Sample.Blue | Should -Be 214
        }
    }
}