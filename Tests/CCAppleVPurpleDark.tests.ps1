Describe 'CCAppleVPurpleDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVPurpleDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVPurpleDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVPurpleDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVPurpleDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 204
            $Sample.Green | Should -Be 101
            $Sample.Blue | Should -Be 255
        }
    }
}