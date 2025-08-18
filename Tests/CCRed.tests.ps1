Describe 'CCRed24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCRed.ps1
    }

    BeforeEach {
        $Sample = [CCRed24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCRed24' {
            $Sample.PSTypeNames | Should -Contain 'CCRed24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 0
            $Sample.Blue | Should -Be 0
        }
    }
}