Describe 'CCAppleVTealDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVTealDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVTealDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVTealDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVTealDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 68
            $Sample.Green | Should -Be 212
            $Sample.Blue | Should -Be 237
        }
    }
}