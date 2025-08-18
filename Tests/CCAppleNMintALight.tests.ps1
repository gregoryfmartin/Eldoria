Describe 'CCAppleNMintALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNMintALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNMintALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNMintALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNMintALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 12
            $Sample.Green | Should -Be 129
            $Sample.Blue | Should -Be 123
        }
    }
}