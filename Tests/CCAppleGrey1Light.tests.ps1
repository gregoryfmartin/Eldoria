Describe 'CCAppleGrey1Light24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGrey1Light.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey1Light24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey1Light24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey1Light24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 142
            $Sample.Green | Should -Be 142
            $Sample.Blue | Should -Be 147
        }
    }
}