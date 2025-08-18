Describe 'CCAppleNCyanDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNCyanDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNCyanDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNCyanDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNCyanDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 100
            $Sample.Green | Should -Be 210
            $Sample.Blue | Should -Be 255
        }
    }
}