Describe 'CCAppleNMintADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNMintADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNMintADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNMintADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNMintADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 102
            $Sample.Green | Should -Be 212
            $Sample.Blue | Should -Be 207
        }
    }
}