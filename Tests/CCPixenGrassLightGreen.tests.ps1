Describe 'CCPixenGrassLightGreen24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCPixenGrassLightGreen.ps1
    }

    BeforeEach {
        $Sample = [CCPixenGrassLightGreen24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCPixenGrassLightGreen24' {
            $Sample.PSTypeNames | Should -Contain 'CCPixenGrassLightGreen24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 209
            $Sample.Blue | Should -Be 66
        }
    }
}