Describe 'CCAppleMintDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAll.ps1
    }

    BeforeEach {
        $Sample = [CCAppleMintDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleMintDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleMintDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 99
            $Sample.Green | Should -Be 230
            $Sample.Blue | Should -Be 226
        }
    }
}