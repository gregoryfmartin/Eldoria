Describe 'CCAppleNGrey5ADark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGrey5ADark.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey5ADark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey5ADark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey5ADark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 54
            $Sample.Green | Should -Be 54
            $Sample.Blue | Should -Be 56
        }
    }
}