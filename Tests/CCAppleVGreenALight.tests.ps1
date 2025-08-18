Describe 'CCAppleVGreenALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVGreenALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVGreenALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVGreenALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVGreenALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 112
            $Sample.Blue | Should -Be 24
        }
    }
}