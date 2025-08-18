Describe 'CCAppleNGrey3Dark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey3Dark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey3Dark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey3Dark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey3Dark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 72
            $Sample.Green | Should -Be 72
            $Sample.Blue | Should -Be 74
        }
    }
}