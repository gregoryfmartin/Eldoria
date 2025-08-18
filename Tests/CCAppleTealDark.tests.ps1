Describe 'CCAppleTealDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleTealDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleTealDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleTealDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleTealDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 64
            $Sample.Green | Should -Be 200
            $Sample.Blue | Should -Be 224
        }
    }
}