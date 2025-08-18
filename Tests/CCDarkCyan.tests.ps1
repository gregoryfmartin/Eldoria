Describe 'CCDarkCyan24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCDarkCyan.ps1
    }

    BeforeEach {
        $Sample = [CCDarkCyan24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCDarkCyan24' {
            $Sample.PSTypeNames | Should -Contain 'CCDarkCyan24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 139
            $Sample.Blue | Should -Be 139
        }
    }
}