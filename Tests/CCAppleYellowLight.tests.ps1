Describe 'CCAppleYellowLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleYellowLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleYellowLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleYellowLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleYellowLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 204
            $Sample.Blue | Should -Be 0
        }
    }
}