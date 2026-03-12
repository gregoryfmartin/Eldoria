Describe 'CCAppleNGrey5Dark24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\TrueColorSupport.ps1
    }

    BeforeEach {
        $Sample = [CCAppleNGrey5Dark24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCAppleNGrey5Dark24' {
            $Sample.PSTypeNames | Should -Contain 'CCAppleNGrey5Dark24'
        }

        It 'Should have populated channels' {
            $Sample.Red | Should -Be 44
            $Sample.Green | Should -Be 44
            $Sample.Blue | Should -Be 46
        }
    }
}