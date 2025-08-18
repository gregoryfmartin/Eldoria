Describe 'CCAppleNGrey5Light24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey5Light.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey5Light24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey5Light24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey5Light24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 229
            $Sample.Green | Should -Be 229
            $Sample.Blue | Should -Be 234
        }
    }
}