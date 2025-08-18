Describe 'CCWhite24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCWhite.ps1
    }

    BeforeEach {
        $Sample = [CCWhite24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCWhite24' {
            $Sample.PSTypeNames | Should -Contain 'CCWhite24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 255
            $Sample.Blue | Should -Be 255
        }
    }
}