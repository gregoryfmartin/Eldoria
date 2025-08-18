Describe 'CCAppleMintLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleMintLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleMintLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleMintLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleMintLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 199
            $Sample.Blue | Should -Be 190
        }
    }
}