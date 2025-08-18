Describe 'CCRandom24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCRandom.ps1
    }

    BeforeEach {
        $Sample = [CCRandom24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCRandom24' {
            $Sample.PSTypeNames | Should -Contain 'CCRandom24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -BeOfType [int]
            $Sample.Green | Should -BeOfType [int]
            $Sample.Blue | Should -BeOfType [int]
        }
    }
}