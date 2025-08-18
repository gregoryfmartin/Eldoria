Describe 'CCAppleVPurpleALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVPurpleALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVPurpleALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVPurpleALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVPurpleALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 173
            $Sample.Green | Should -Be 68
            $Sample.Blue | Should -Be 171
        }
    }
}