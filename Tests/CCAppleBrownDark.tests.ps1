Describe 'CCAppleBrownDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleBrownDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleBrownDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleBrownDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleBrownDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 172
            $Sample.Green | Should -Be 142
            $Sample.Blue | Should -Be 104
        }
    }
}