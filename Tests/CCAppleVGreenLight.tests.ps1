Describe 'CCAppleVGreenLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVGreenLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVGreenLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVGreenLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVGreenLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 30
            $Sample.Green | Should -Be 195
            $Sample.Blue | Should -Be 55
        }
    }
}