Describe 'CCAppleNGreyDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGreyDark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGreyDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGreyDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGreyDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 142
            $Sample.Green | Should -Be 142
            $Sample.Blue | Should -Be 147
        }
    }
}