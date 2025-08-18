Describe 'CCAppleVGreyLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVGreyLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVGreyLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVGreyLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVGreyLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 132
            $Sample.Green | Should -Be 132
            $Sample.Blue | Should -Be 137
        }
    }
}