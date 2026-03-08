Describe 'CCAppleVGreenDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAll.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVGreenDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVGreenDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVGreenDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 60
            $Sample.Green | Should -Be 225
            $Sample.Blue | Should -Be 85
        }
    }
}