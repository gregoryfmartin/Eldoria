Describe 'CCGreen24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCGreen.ps1
    }

    BeforeEach {
        $Sample = [CCGreen24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCGreen24' {
            $Sample.PSTypeNames | Should -Contain 'CCGreen24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 255
            $Sample.Blue | Should -Be 0
        }
    }
}