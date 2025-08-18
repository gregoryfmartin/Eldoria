Describe 'CCAppleNGrey6ALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey6ALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey6ALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey6ALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey6ALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 235
            $Sample.Green | Should -Be 235
            $Sample.Blue | Should -Be 240
        }
    }
}