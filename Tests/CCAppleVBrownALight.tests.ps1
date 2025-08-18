Describe 'CCAppleVBrownALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVBrownALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVBrownALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVBrownALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVBrownALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 119
            $Sample.Green | Should -Be 93
            $Sample.Blue | Should -Be 59
        }
    }
}