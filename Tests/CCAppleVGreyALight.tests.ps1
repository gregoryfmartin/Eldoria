Describe 'CCAppleVGreyALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVGreyALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVGreyALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVGreyALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVGreyALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 97
            $Sample.Green | Should -Be 97
            $Sample.Blue | Should -Be 101
        }
    }
}