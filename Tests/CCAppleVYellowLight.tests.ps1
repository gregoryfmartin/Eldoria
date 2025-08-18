Describe 'CCAppleVYellowLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVYellowLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVYellowLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVYellowLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVYellowLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 245
            $Sample.Green | Should -Be 194
            $Sample.Blue | Should -Be 0
        }
    }
}