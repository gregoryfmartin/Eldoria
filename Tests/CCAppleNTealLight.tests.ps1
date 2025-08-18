Describe 'CCAppleNTealLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNTealLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNTealLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNTealLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNTealLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 48
            $Sample.Green | Should -Be 176
            $Sample.Blue | Should -Be 199
        }
    }
}