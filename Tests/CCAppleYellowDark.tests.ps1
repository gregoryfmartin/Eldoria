Describe 'CCAppleYellowDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleYellowDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleYellowDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleYellowDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleYellowDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 214
            $Sample.Blue | Should -Be 10
        }
    }
}