Describe 'CCAppleNPinkLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAll.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNPinkLight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNPinkLight24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNPinkLight24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 45
            $Sample.Blue | Should -Be 85
        }
    }
}