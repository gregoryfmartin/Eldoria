Describe 'CCAppleRedLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAll.ps1
    }

    BeforeEach {
        $Sample = [CCAppleRedLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleRedLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleRedLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 59
            $Sample.Blue | Should -Be 48
        }
    }
}