Describe 'CCAppleNOrangeDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNOrangeDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNOrangeDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNOrangeDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNOrangeDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 159
            $Sample.Blue | Should -Be 10
        }
    }
}