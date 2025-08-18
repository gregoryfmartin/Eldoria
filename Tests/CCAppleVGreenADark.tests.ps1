Describe 'CCAppleVGreenADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVGreenADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVGreenADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVGreenADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVGreenADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 49
            $Sample.Green | Should -Be 222
            $Sample.Blue | Should -Be 75
        }
    }
}