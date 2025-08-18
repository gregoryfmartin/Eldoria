Describe 'CCAppleVYellowDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVYellowDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVYellowDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVYellowDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVYellowDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 224
            $Sample.Blue | Should -Be 20
        }
    }
}