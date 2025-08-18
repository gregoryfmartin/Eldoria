Describe 'CCBlack24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCBlack.ps1
    }

    BeforeEach {
        $Sample = [CCBlack24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCBlack24' {
            $Sample.PSTypeNames | Should -Contain 'CCBlack24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 0
            $Sample.Blue | Should -Be 0
        }
    }
}