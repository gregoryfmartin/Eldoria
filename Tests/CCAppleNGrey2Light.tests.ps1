Describe 'CCAppleNGrey2Light24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey2Light.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey2Light24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey2Light24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey2Light24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 174
            $Sample.Green | Should -Be 174
            $Sample.Blue | Should -Be 178
        }
    }
}