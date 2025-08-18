Describe 'CCAppleVMintALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVMintALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVMintALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVMintALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVMintALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 11
            $Sample.Green | Should -Be 117
            $Sample.Blue | Should -Be 112
        }
    }
}