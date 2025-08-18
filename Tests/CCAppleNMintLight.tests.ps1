Describe 'CCAppleNMintLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNMintLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNMintLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNMintLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNMintLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 199
            $Sample.Blue | Should -Be 190
        }
    }
}