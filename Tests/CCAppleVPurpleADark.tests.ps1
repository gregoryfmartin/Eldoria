Describe 'CCAppleVPurpleADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVPurpleADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVPurpleADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVPurpleADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVPurpleADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 218
            $Sample.Green | Should -Be 143
            $Sample.Blue | Should -Be 255
        }
    }
}