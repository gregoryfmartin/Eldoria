Describe 'CCAppleVBlueLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVBlueLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVBlueLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVBlueLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVBlueLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 122
            $Sample.Blue | Should -Be 245
        }
    }
}