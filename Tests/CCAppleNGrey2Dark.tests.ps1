Describe 'CCAppleNGrey2Dark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey2Dark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey2Dark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey2Dark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey2Dark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 99
            $Sample.Green | Should -Be 99
            $Sample.Blue | Should -Be 102
        }
    }
}