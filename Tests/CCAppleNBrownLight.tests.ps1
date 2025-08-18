Describe 'CCAppleNBrownLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNBrownLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNBrownLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNBrownLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNBrownLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 162
            $Sample.Green | Should -Be 132
            $Sample.Blue | Should -Be 94
        }
    }
}