Describe 'CCPixenRoadDarkBrown24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCPixenRoadDarkBrown.ps1
    }

    BeforeEach {
        $Sample = [CCPixenRoadDarkBrown24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCPixenRoadDarkBrown24' {
            $Sample.PSTypeNames | Should -Contain 'CCPixenRoadDarkBrown24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 122
            $Sample.Green | Should -Be 67
            $Sample.Blue | Should -Be 0
        }
    }
}