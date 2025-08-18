Describe 'CCAppleVTealADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVTealADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVTealADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVTealADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVTealADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 93
            $Sample.Green | Should -Be 230
            $Sample.Blue | Should -Be 255
        }
    }
}