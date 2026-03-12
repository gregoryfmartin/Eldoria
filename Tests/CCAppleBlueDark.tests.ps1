Describe 'CCAppleBlueDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\TrueColorSupport.ps1
    }

    BeforeEach {
        $Sample = [CCAppleBlueDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleBlueDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleBlueDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 10
            $Sample.Green | Should -Be 132
            $Sample.Blue | Should -Be 255
        }
    }
}