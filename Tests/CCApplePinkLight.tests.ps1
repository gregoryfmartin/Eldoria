Describe 'CCApplePinkLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCApplePinkLight.ps1
    }

    BeforeEach {
        $Sample = [CCApplePinkLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCApplePinkLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCApplePinkLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 45
            $Sample.Blue | Should -Be 85
        }
    }
}