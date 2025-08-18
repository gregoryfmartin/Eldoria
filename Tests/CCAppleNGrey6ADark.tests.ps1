Describe 'CCAppleNGrey6ADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey6ADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey6ADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey6ADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey6ADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 36
            $Sample.Green | Should -Be 36
            $Sample.Blue | Should -Be 38
        }
    }
}