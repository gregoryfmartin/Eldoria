Describe 'CCAppleNTealALight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNTealALight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNTealALight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNTealALight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNTealALight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 0
            $Sample.Green | Should -Be 130
            $Sample.Blue | Should -Be 153
        }
    }
}