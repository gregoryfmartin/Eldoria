Describe 'CCAppleNGrey4ALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey4ALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey4ALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey4ALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey4ALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 188
            $Sample.Green | Should -Be 188
            $Sample.Blue | Should -Be 192
        }
    }
}