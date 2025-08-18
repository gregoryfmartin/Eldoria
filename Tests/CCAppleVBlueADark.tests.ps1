Describe 'CCAppleVBlueADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVBlueADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVBlueADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVBlueADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVBlueADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 64
            $Sample.Green | Should -Be 156
            $Sample.Blue | Should -Be 255
        }
    }
}