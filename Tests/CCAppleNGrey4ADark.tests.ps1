Describe 'CCAppleNGrey4ADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey4ADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey4ADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey4ADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey4ADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 68
            $Sample.Green | Should -Be 68
            $Sample.Blue | Should -Be 70
        }
    }
}