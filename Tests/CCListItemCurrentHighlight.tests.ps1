Describe 'CCListItemCurrentHighlight24' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ConsoleColor\ConsoleColor24.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCAppleNPinkLight.ps1
        . $PSScriptRoot\..\Classes\ConsoleColor\CCListItemCurrentHighlight.ps1
    }

    BeforeEach {
        $Sample = [CCListItemCurrentHighlight24]::new()
    }

    AfterEach {
        $Sample = $null
    }

    Context 'Initializtion' {
        It 'Should create a new instance of CCListItemCurrentHighlight24' {
            $Sample.PSTypeNames | Should -Contain 'CCListItemCurrentHighlight24'
        }

        It 'Should have populated channels from inherited class' {
            $Sample.Red | Should -Be 255
            $Sample.Green | Should -Be 45
            $Sample.Blue | Should -Be 85
        }
    }
}