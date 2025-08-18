Describe 'CCAppleNGreenALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGreenALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGreenALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGreenALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGreenALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 36
            $Sample.Green | Should -Be 138
            $Sample.Blue | Should -Be 61
        }
    }
}