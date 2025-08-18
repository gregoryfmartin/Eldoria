Describe 'CCApplePinkDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCApplePinkDark.ps1
    }

    BeforeEach {
        $Sample = [CCApplePinkDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCApplePinkDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCApplePinkDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 55
            $Sample.Blue | Should -Be 95
        }
    }
}