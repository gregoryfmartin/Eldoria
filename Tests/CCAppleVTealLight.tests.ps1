Describe 'CCAppleVTealLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVTealLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVTealLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVTealLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVTealLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 46
            $Sample.Green | Should -Be 167
            $Sample.Blue | Should -Be 189
        }
    }
}