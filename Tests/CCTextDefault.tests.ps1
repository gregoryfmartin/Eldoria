Describe 'CCTextDefault24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleGrey5Light.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCTextDefault.ps1
    }

    BeforeEach {
        $Sample = [CCTextDefault24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCTextDefault24' {
            $Sample.PSTypeNames | Should -Contain 'CCTextDefault24'
        }

        It 'Should have populated channels from inherited class' {
            $Sample.Red | Should -Be 229
            $Sample.Green | Should -Be 229
            $Sample.Blue | Should -Be 234
        }
    }
}