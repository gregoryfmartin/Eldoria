Describe 'CCAppleVCyanADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVCyanADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVCyanADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVCyanADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVCyanADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 112
            $Sample.Green | Should -Be 215
            $Sample.Blue | Should -Be 255
        }
    }
}