Describe 'CCAppleVBrownLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVBrownLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVBrownLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVBrownLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVBrownLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 152
            $Sample.Green | Should -Be 122
            $Sample.Blue | Should -Be 84
        }
    }
}