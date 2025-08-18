Describe 'CCAppleVIndigoLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVIndigoLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVIndigoLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVIndigoLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVIndigoLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 84
            $Sample.Green | Should -Be 82
            $Sample.Blue | Should -Be 204
        }
    }
}