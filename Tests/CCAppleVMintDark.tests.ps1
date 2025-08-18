Describe 'CCAppleVMintDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVMintDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVMintDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVMintDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVMintDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 108
            $Sample.Green | Should -Be 224
            $Sample.Blue | Should -Be 219
        }
    }
}