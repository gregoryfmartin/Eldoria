Describe 'CCAppleBlueLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleBlueLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleBlueLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleBlueLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleBlueLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 122
            $Sample.Blue | Should -Be 255
        }
    }
}