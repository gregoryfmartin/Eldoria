Describe 'CCAppleOrangeLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleOrangeLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleOrangeLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleOrangeLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleOrangeLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 149
            $Sample.Blue | Should -Be 0
        }
    }
}