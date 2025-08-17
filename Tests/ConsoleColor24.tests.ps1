Describe 'ConsoleColor24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
    }

    BeforeEach {
        $Sample = [ConsoleColor24]::new(255, 255, 255)
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of ConsoleColor24' {
            $Sample.PSTypeNames | Should -Contain 'ConsoleColor24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 255
            $Sample.Blue | Should -Be 255
        }
    }

    Context 'Channel Manipulation' {
        It 'Should assign a value within tolerance' {
            $Sample.Red = 15
            $Sample.Red | Should -Be 15
        }

        It 'Should complain if a value is assigned below tolerance' {
            { $Sample.Red = -15 } | Should -Throw
        }

        It 'Should complain if a value is assigned above tolerance' {
            { $Sample.Red = 500 } | Should -Throw
        }
    }
}