Describe 'CCAppleVCyanDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVCyanDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVCyanDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVCyanDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVCyanDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 90
            $Sample.Green | Should -Be 205
            $Sample.Blue | Should -Be 250
        }
    }
}