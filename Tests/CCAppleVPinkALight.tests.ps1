Describe 'CCAppleVPinkALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVPinkALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVPinkALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVPinkALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVPinkALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 193
            $Sample.Green | Should -Be 16
            $Sample.Blue | Should -Be 50
        }
    }
}