Describe 'CCAppleNBlueALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNBlueALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNBlueALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNBlueALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNBlueALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 64
            $Sample.Blue | Should -Be 221
        }
    }
}