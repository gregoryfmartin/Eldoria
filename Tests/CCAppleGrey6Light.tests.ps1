Describe 'CCAppleGrey6Light24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGrey6Light.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey6Light24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey6Light24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey6Light24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 242
            $Sample.Green | Should -Be 242
            $Sample.Blue | Should -Be 247
        }
    }
}