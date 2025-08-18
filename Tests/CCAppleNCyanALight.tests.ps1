Describe 'CCAppleNCyanALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNCyanALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNCyanALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNCyanALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNCyanALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 113
            $Sample.Blue | Should -Be 164
        }
    }
}