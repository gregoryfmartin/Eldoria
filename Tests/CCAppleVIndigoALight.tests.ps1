Describe 'CCAppleVIndigoALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVIndigoALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVIndigoALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVIndigoALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVIndigoALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 54
            $Sample.Green | Should -Be 52
            $Sample.Blue | Should -Be 163
        }
    }
}