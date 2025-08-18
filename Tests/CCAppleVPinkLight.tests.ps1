Describe 'CCAppleVPinkLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVPinkLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVPinkLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVPinkLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVPinkLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 245
            $Sample.Green | Should -Be 35
            $Sample.Blue | Should -Be 75
        }
    }
}