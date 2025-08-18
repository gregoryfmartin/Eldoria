Describe 'CCAppleVGreyADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVGreyADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVGreyADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVGreyADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVGreyADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 152
            $Sample.Green | Should -Be 152
            $Sample.Blue | Should -Be 157
        }
    }
}