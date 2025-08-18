Describe 'CCPantoneSkyBlue24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCPantoneSkyBlue.ps1
    }

    BeforeEach {
        $Sample = [CCPantoneSkyBlue24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCPantoneSkyBlue24' {
            $Sample.PSTypeNames | Should -Contain 'CCPantoneSkyBlue24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 54
            $Sample.Green | Should -Be 73
            $Sample.Blue | Should -Be 83
        }
    }
}