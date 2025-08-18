Describe 'CCAppleVBlueDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVBlueDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVBlueDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVBlueDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVBlueDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 20
            $Sample.Green | Should -Be 142
            $Sample.Blue | Should -Be 255
        }
    }
}