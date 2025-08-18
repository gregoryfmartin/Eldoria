Describe 'CCAppleVIndigoDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVIndigoDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVIndigoDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVIndigoDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVIndigoDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 99
            $Sample.Green | Should -Be 97
            $Sample.Blue | Should -Be 242
        }
    }
}