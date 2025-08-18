Describe 'CCAppleVPinkADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVPinkADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVPinkADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVPinkADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVPinkADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 58
            $Sample.Blue | Should -Be 95
        }
    }
}