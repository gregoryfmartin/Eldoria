Describe 'CCAppleNGrey6Light24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey6Light.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey6Light24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey6Light24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey6Light24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 242
            $Sample.Green | Should -Be 242
            $Sample.Blue | Should -Be 247
        }
    }
}