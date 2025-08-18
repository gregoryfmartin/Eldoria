Describe 'CCAppleVRedLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleVRedLight.ps1
    }

    BeforeEach {
        $Sample = [CCAppleVRedLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleVRedLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleVRedLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 49
            $Sample.Blue | Should -Be 38
        }
    }
}