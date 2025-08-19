Describe 'ATDecorationNone Class' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATDecoration.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATDecorationNone.ps1
    }

    Context 'Constructor' {
        It 'Should initialize with all decoration properties set to false' {
            [ATDecorationNone]$Sample = [ATDecorationNone]::new()

            $Sample.Blink | Should -Be $false
            $Sample.Italic | Should -Be $false
            $Sample.Underline | Should -Be $false
            $Sample.Strikethru | Should -Be $false
        }
    }

    Context 'Methods' {
        It 'ToAnsiControlSequenceString() should return an empty string' {
            [ATDecorationNone]$Sample = [ATDecorationNone]::new()
            [String]$Result           = $Sample.ToAnsiControlSequenceString()

            $result | Should -Be ''
        }
    }
}

