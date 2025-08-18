Describe 'CCAppleIndigoLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleIndigoLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleIndigoLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleIndigoLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleIndigoLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 88
            $Sample.Green | Should -Be 86
            $Sample.Blue | Should -Be 214
        }
    }
}