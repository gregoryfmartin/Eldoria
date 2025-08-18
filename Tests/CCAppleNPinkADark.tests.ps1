Describe 'CCAppleNPinkADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNPinkADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNPinkADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNPinkADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNPinkADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 100
            $Sample.Blue | Should -Be 130
        }
    }
}