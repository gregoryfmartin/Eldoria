Describe 'CCAppleVOrangeLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVOrangeLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVOrangeLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVOrangeLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVOrangeLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 245
            $Sample.Green | Should -Be 139
            $Sample.Blue | Should -Be 0
        }
    }
}