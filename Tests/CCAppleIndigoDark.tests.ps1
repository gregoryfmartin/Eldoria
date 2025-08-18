Describe 'CCAppleIndigoDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleIndigoDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleIndigoDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleIndigoDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleIndigoDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 94
            $Sample.Green | Should -Be 92
            $Sample.Blue | Should -Be 230
        }
    }
}