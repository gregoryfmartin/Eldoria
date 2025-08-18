Describe 'CCAppleNGreyADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGreyADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGreyADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGreyADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGreyADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 174
            $Sample.Green | Should -Be 174
            $Sample.Blue | Should -Be 178
        }
    }
}