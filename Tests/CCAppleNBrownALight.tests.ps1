Describe 'CCAppleNBrownALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNBrownALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNBrownALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNBrownALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNBrownALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 127
            $Sample.Green | Should -Be 101
            $Sample.Blue | Should -Be 69
        }
    }
}