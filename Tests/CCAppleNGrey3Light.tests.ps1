Describe 'CCAppleNGrey3Light24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey3Light.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey3Light24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey3Light24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey3Light24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 199
            $Sample.Green | Should -Be 199
            $Sample.Blue | Should -Be 204
        }
    }
}