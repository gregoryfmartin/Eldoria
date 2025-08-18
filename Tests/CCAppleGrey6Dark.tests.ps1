Describe 'CCAppleGrey6Dark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGrey6Dark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey6Dark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey6Dark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey6Dark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 28
            $Sample.Green | Should -Be 28
            $Sample.Blue | Should -Be 30
        }
    }
}