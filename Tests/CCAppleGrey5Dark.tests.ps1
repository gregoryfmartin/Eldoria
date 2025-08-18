Describe 'CCAppleGrey5Dark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGrey5Dark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey5Dark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey5Dark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey5Dark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 44
            $Sample.Green | Should -Be 44
            $Sample.Blue | Should -Be 46
        }
    }
}