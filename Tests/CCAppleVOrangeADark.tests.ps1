Describe 'CCAppleVOrangeADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVOrangeADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVOrangeADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVOrangeADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVOrangeADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 179
            $Sample.Blue | Should -Be 64
        }
    }
}