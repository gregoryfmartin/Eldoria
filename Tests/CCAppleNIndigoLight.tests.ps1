Describe 'CCAppleNIndigoLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNIndigoLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNIndigoLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNIndigoLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNIndigoLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 88
            $Sample.Green | Should -Be 86
            $Sample.Blue | Should -Be 214
        }
    }
}