Describe 'CCAppleVBrownDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVBrownDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVBrownDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVBrownDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVBrownDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 182
            $Sample.Green | Should -Be 152
            $Sample.Blue | Should -Be 114
        }
    }
}