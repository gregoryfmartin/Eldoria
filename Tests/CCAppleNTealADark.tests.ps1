Describe 'CCAppleNTealADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNTealADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNTealADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNTealADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNTealADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 93
            $Sample.Green | Should -Be 230
            $Sample.Blue | Should -Be 255
        }
    }
}