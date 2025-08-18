Describe 'CCAppleNGreyALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGreyALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGreyALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGreyALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGreyALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 108
            $Sample.Green | Should -Be 108
            $Sample.Blue | Should -Be 112
        }
    }
}