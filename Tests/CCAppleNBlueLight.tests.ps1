Describe 'CCAppleNBlueLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNBlueLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNBlueLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNBlueLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNBlueLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 122
            $Sample.Blue | Should -Be 255
        }
    }
}