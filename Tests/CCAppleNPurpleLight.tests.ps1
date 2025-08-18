Describe 'CCAppleNPurpleLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNPurpleLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNPurpleLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNPurpleLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNPurpleLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 175
            $Sample.Green | Should -Be 82
            $Sample.Blue | Should -Be 222
        }
    }
}