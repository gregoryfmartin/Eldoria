# This assumes your test runner can locate and load these class files.
# A common pattern is to have a build/test script that handles dot-sourcing.
# For simplicity, we'll assume the classes are available.
# If running this file directly, you would need something like:
# . (Join-Path $PSScriptRoot '..\..\..\Classes\ATStrings\ATControlSequences.ps1')
# . (Join-Path $PSScriptRoot '..\..\..\Classes\ATStrings\ATDecoration.ps1')

Describe 'ATDecoration Class' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATDecoration.ps1
    }

    Context 'Constructors' {
        It 'Should initialize with all decorations set to false by default' {
            [ATDecoration]$Sample = [ATDecoration]::new()

            $Sample.Blink | Should -Be $false
            $Sample.Italic | Should -Be $false
            $Sample.Underline | Should -Be $false
            $Sample.Strikethru | Should -Be $false
        }

        It 'Should initialize properties correctly from a hashtable' {
            [ATDecoration]$Sample = [ATDecoration]@{
                Blink   = $true
                Italic  = $false
                Underline = $true
            }

            $Sample.Blink | Should -Be $true
            $Sample.Italic | Should -Be $false
            $Sample.Underline | Should -Be $true
            $Sample.Strikethru | Should -Be $false
        }
    }

    Context 'ToAnsiControlSequenceString Method' {
        It 'Should return an empty string when no decorations are set' {
            [ATDecoration]$Sample = [ATDecoration]::new()

            $Sample.ToAnsiControlSequenceString() | Should -Be ''
        }

        It 'Should return the correct sequence for a single decoration (Blink)' {
            [ATDecoration]$Sample   = [ATDecoration]@{ Blink = $true }
            [String]$ExpectedResult = [ATControlSequences]::DecorationBlink

            $Sample.ToAnsiControlSequenceString() | Should -Be $ExpectedResult
        }

        It 'Should return the correct sequence for a single decoration (Italic)' {
            [ATDecoration]$Sample   = [ATDecoration]@{ Italic = $true }
            [String]$ExpectedResult = [ATControlSequences]::DecorationItalic

            $Sample.ToAnsiControlSequenceString() | Should -Be $ExpectedResult
        }

        It 'should return a combined sequence for multiple decorations' {
            [ATDecoration]$Sample = [ATDecoration]@{
                Blink     = $true
                Underline = $true
            }
            [String]$ExpectedResult = "$([ATControlSequences]::DecorationBlink)$([ATControlSequences]::DecorationUnderline)"

            $Sample.ToAnsiControlSequenceString() | Should -Be $ExpectedResult
        }

        It 'Should return a combined sequence for all decorations' {
            [ATDecoration]$Sample = [ATDecoration]@{
                Blink      = $true
                Italic     = $true
                Underline  = $true
                Strikethru = $true
            }
            [String]$ExpectedResult = "$([ATControlSequences]::DecorationBlink)$([ATControlSequences]::DecorationItalic)$([ATControlSequences]::DecorationUnderline)$([ATControlSequences]::DecorationStrikethru)"
            
            $Sample.ToAnsiControlSequenceString() | Should -Be $ExpectedResult
        }
    }
}

