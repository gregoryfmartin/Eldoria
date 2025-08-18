Describe 'CCAppleNGreenLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGreenLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGreenLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGreenLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGreenLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 52
            $Sample.Green | Should -Be 199
            $Sample.Blue | Should -Be 89
        }
    }
}