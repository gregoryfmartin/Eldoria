Describe 'CCAppleVOrangeALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVOrangeALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVOrangeALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVOrangeALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVOrangeALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 173
            $Sample.Green | Should -Be 58
            $Sample.Blue | Should -Be 0
        }
    }
}