Describe 'CCAppleNGrey2ALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey2ALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey2ALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey2ALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey2ALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 142
            $Sample.Green | Should -Be 142
            $Sample.Blue | Should -Be 147
        }
    }
}