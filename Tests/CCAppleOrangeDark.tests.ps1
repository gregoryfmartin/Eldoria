Describe 'CCAppleOrangeDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleOrangeDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleOrangeDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleOrangeDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleOrangeDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 159
            $Sample.Blue | Should -Be 10
        }
    }
}