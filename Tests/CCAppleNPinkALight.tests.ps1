Describe 'CCAppleNPinkALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNPinkALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNPinkALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNPinkALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNPinkALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 211
            $Sample.Green | Should -Be 15
            $Sample.Blue | Should -Be 69
        }
    }
}