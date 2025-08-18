Describe 'CCAppleNGrey6Dark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey6Dark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey6Dark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey6Dark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey6Dark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 28
            $Sample.Green | Should -Be 28
            $Sample.Blue | Should -Be 30
        }
    }
}