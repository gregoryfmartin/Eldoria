Describe 'CCAppleVGreyLight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\TrueColorSupport.ps1
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