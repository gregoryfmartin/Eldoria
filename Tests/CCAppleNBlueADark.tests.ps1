Describe 'CCAppleNBlueADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNBlueADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNBlueADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNBlueADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNBlueADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 64
            $Sample.Green | Should -Be 156
            $Sample.Blue | Should -Be 255
        }
    }
}