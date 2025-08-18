Describe 'CCDarkYellow24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCDarkYellow.ps1
    }

    BeforeEach {
        $Sample = [CCDarkYellow24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCDarkYellow24' {
            $Sample.PSTypeNames | Should -Contain 'CCDarkYellow24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 204
            $Sample.Blue | Should -Be 0
        }
    }
}