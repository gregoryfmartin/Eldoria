Describe 'CCAppleVTealALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVTealALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVTealALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVTealALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVTealALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 119
            $Sample.Blue | Should -Be 140
        }
    }
}