Describe 'CCDarkGrey24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCDarkGrey.ps1
    }

    BeforeEach {
        $Sample = [CCDarkGrey24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCDarkGrey24' {
            $Sample.PSTypeNames | Should -Contain 'CCDarkGrey24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 45
            $Sample.Green | Should -Be 45
            $Sample.Blue | Should -Be 45
        }
    }
}