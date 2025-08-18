Describe 'CCAppleVMintLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVMintLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVMintLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVMintLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVMintLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 189
            $Sample.Blue | Should -Be 180
        }
    }
}