Describe 'CCAppleVOrangeDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVOrangeDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVOrangeDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVOrangeDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVOrangeDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 169
            $Sample.Blue | Should -Be 20
        }
    }
}