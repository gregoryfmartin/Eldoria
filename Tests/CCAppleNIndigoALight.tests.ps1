Describe 'CCAppleNIndigoALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNIndigoALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNIndigoALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNIndigoALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNIndigoALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 54
            $Sample.Green | Should -Be 52
            $Sample.Blue | Should -Be 163
        }
    }
}