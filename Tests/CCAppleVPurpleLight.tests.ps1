Describe 'CCAppleVPurpleLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVPurpleLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVPurpleLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVPurpleLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVPurpleLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 159
            $Sample.Green | Should -Be 75
            $Sample.Blue | Should -Be 201
        }
    }
}