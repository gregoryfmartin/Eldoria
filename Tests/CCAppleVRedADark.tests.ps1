Describe 'CCAppleVRedADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVRedADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVRedADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVRedADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVRedADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 65
            $Sample.Blue | Should -Be 54
        }
    }
}