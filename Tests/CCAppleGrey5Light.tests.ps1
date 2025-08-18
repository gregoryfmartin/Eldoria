Describe 'CCAppleGrey5Light24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGrey5Light.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey5Light24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey5Light24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey5Light24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 229
            $Sample.Green | Should -Be 229
            $Sample.Blue | Should -Be 234
        }
    }
}