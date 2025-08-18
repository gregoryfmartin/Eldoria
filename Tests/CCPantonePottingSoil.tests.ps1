Describe 'CCPantonePottingSoil24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCPantonePottingSoil.ps1
    }

    BeforeEach {
        $Sample = [CCPantonePottingSoil24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCPantonePottingSoil24' {
            $Sample.PSTypeNames | Should -Contain 'CCPantonePottingSoil24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 33
            $Sample.Green | Should -Be 22
            $Sample.Blue | Should -Be 18
        }
    }
}