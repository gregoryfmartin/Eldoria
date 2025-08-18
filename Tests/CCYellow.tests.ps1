Describe 'CCYellow24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCYellow.ps1
    }

    BeforeEach {
        $Sample = [CCYellow24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCYellow24' {
            $Sample.PSTypeNames | Should -Contain 'CCYellow24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 255
            $Sample.Blue | Should -Be 0
        }
    }
}