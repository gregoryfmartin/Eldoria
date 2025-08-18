Describe 'CCAppleNRedALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNRedALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNRedALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNRedALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNRedALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 215
            $Sample.Green | Should -Be 0
            $Sample.Blue | Should -Be 21
        }
    }
}