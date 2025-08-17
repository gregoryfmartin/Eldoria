Describe 'CCAppleGrey3Light24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGrey3Light.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey3Light24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey3Light24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey3Light24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 199
            $Sample.Green | Should -Be 199
            $Sample.Blue | Should -Be 204
        }
    }
}