Describe 'CCAppleNCyanADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNCyanADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNCyanADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNCyanADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNCyanADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 112
            $Sample.Green | Should -Be 215
            $Sample.Blue | Should -Be 255
        }
    }
}