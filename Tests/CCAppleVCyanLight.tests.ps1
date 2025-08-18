Describe 'CCAppleVCyanLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVCyanLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVCyanLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVCyanLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVCyanLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 65
            $Sample.Green | Should -Be 175
            $Sample.Blue | Should -Be 220
        }
    }
}