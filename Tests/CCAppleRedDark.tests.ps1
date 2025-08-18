Describe 'CCAppleRedDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleRedDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleRedDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleRedDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleRedDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 69
            $Sample.Blue | Should -Be 58
        }
    }
}