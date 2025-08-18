Describe 'CCAppleNGrey2ADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey2ADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey2ADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey2ADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey2ADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 124
            $Sample.Green | Should -Be 124
            $Sample.Blue | Should -Be 128
        }
    }
}