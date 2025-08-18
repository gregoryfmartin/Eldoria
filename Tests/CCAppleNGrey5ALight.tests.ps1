Describe 'CCAppleNGrey5ALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey5ALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey5ALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey5ALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey5ALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 216
            $Sample.Green | Should -Be 216
            $Sample.Blue | Should -Be 220
        }
    }
}