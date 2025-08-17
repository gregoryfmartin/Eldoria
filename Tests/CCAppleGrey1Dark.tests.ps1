Describe 'CCAppleGrey1Dark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGrey1Dark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey1Dark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey1Dark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey1Dark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 142
            $Sample.Green | Should -Be 142
            $Sample.Blue | Should -Be 147
        }
    }
}