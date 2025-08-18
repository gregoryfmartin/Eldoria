Describe 'CCAppleVIndigoADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVIndigoADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVIndigoADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVIndigoADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVIndigoADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 125
            $Sample.Green | Should -Be 122
            $Sample.Blue | Should -Be 255
        }
    }
}