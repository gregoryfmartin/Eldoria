Describe 'CCAppleNOrangeALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNOrangeALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNOrangeALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNOrangeALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNOrangeALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 201
            $Sample.Green | Should -Be 52
            $Sample.Blue | Should -Be 0
        }
    }
}