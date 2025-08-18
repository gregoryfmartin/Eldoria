Describe 'CCAppleNIndigoDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNIndigoDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNIndigoDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNIndigoDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNIndigoDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 94
            $Sample.Green | Should -Be 92
            $Sample.Blue | Should -Be 230
        }
    }
}