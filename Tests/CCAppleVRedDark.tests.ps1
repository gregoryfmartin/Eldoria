Describe 'CCAppleVRedDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVRedDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVRedDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVRedDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVRedDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 79
            $Sample.Blue | Should -Be 68
        }
    }
}