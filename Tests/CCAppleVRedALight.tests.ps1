Describe 'CCAppleVRedALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVRedALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVRedALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVRedALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVRedALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 194
            $Sample.Green | Should -Be 6
            $Sample.Blue | Should -Be 24
        }
    }
}