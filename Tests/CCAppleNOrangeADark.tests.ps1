Describe 'CCAppleNOrangeADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNOrangeADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNOrangeADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNOrangeADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNOrangeADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 179
            $Sample.Blue | Should -Be 64
        }
    }
}