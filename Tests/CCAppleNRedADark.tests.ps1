Describe 'CCAppleNRedADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNRedADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNRedADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNRedADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNRedADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 105
            $Sample.Blue | Should -Be 97
        }
    }
}