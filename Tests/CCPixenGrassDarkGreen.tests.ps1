Describe 'CCPixenGrassDarkGreen24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCPixenGrassDarkGreen.ps1
    }

    BeforeEach {
        $Sample = [CCPixenGrassDarkGreen24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCPixenGrassDarkGreen24' {
            $Sample.PSTypeNames | Should -Contain 'CCPixenGrassDarkGreen24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 165
            $Sample.Blue | Should -Be 0
        }
    }
}