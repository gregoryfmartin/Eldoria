Describe 'CCAppleNGreyLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNGreyLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGreyLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGreyLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGreyLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 142
            $Sample.Green | Should -Be 142
            $Sample.Blue | Should -Be 147
        }
    }
}