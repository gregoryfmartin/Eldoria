Describe 'CCAppleNTealDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNTealDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNTealDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNTealDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNTealDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 64
            $Sample.Green | Should -Be 200
            $Sample.Blue | Should -Be 224
        }
    }
}