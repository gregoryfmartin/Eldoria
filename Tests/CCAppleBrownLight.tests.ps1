Describe 'CCAppleBrownLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleBrownLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleBrownLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleBrownLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleBrownLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 162
            $Sample.Green | Should -Be 132
            $Sample.Blue | Should -Be 94
        }
    }
}