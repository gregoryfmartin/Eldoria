Describe 'CCAppleGrey4Dark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\TrueColorSupport.ps1
    }

    BeforeEach {
        $Sample = [CCAppleGrey4Dark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleGrey4Dark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleGrey4Dark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 58
            $Sample.Green | Should -Be 58
            $Sample.Blue | Should -Be 60
        }
    }
}