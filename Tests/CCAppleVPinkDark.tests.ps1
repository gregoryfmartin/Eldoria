Describe 'CCAppleVPinkDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVPinkDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVPinkDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVPinkDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVPinkDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 65
            $Sample.Blue | Should -Be 105
        }
    }
}