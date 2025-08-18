Describe 'CCAppleNPurpleDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNPurpleDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNPurpleDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNPurpleDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNPurpleDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 191
            $Sample.Green | Should -Be 90
            $Sample.Blue | Should -Be 242
        }
    }
}