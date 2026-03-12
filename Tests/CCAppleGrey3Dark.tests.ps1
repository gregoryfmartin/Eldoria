Describe 'CCAppleGrey3Dark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\TrueColorSupport.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey3Dark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey3Dark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey3Dark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 72
            $Sample.Green | Should -Be 72
            $Sample.Blue | Should -Be 74
        }
    }
}