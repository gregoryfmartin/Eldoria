Describe 'CCAppleNRedDark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\TrueColorSupport.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNRedDark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNRedDark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNRedDark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 69
            $Sample.Blue | Should -Be 58
        }
    }
}