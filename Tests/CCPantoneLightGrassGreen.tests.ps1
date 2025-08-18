Describe 'CCPantoneLightGrassGreen24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCPantoneLightGrassGreen.ps1
    }

    BeforeEach {
        $Sample = [CCPantoneLightGrassGreen24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCPantoneLightGrassGreen24' {
            $Sample.PSTypeNames | Should -Contain 'CCPantoneLightGrassGreen24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 49
            $Sample.Green | Should -Be 70
            $Sample.Blue | Should -Be 53
        }
    }
}