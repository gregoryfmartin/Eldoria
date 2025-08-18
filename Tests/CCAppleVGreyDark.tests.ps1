Describe 'CCAppleVGreyDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVGreyDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVGreyDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVGreyDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVGreyDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 162
            $Sample.Green | Should -Be 162
            $Sample.Blue | Should -Be 167
        }
    }
}