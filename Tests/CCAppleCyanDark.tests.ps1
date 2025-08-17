Describe 'CCAppleCyanDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleCyanDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleCyanDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleCyanDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleCyanDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 100
            $Sample.Green | Should -Be 210
            $Sample.Blue | Should -Be 255
        }
    }
}