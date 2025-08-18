Describe 'CCAppleNPurpleALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNPurpleALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNPurpleALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNPurpleALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNPurpleALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 137
            $Sample.Green | Should -Be 68
            $Sample.Blue | Should -Be 171
        }
    }
}