using namespace System.Management.Automation.Host

# This assumes your test runner can locate and load these class files.
# A common pattern is to have a build/test script that handles dot-sourcing.
# For simplicity, we'll assume the classes are available.
# If running this file directly, you would need something like:
# . (Join-Path $PSScriptRoot '..\..\..\Classes\ATStrings\ATControlSequences.ps1')
# . (Join-Path $PSScriptRoot '..\..\..\Classes\ATStrings\ATCoordinates.ps1')

Describe 'ATCoordinates Class' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATCoordinates.ps1
    }
    
    Context 'Constructors' {
        It 'Should initialize with default values (Row=1, Column=1) when using the default constructor' {
            [ATCoordinates]$Sample = [ATCoordinates]::new()

            $Sample.Row | Should -Be 1
            $Sample.Column | Should -Be 1
        }

        It 'Should initialize with provided Row and Column integer values' {
            [ATCoordinates]$Sample = [ATCoordinates]::new(10, 20)

            $Sample.Row | Should -Be 10
            $Sample.Column | Should -Be 20
        }

        It 'Should handle zero and negative values for Row and Column' {
            [ATCoordinates]$Sample = [ATCoordinates]::new(0, -5)

            $Sample.Row | Should -Be 0
            $Sample.Column | Should -Be -5
        }

        It 'Should initialize from a System.Management.Automation.Host.Coordinates object' {
            [Coordinates]$SampleAutomationCoords = [Coordinates]::new(30, 40)
            [ATCoordinates]$Sample               = [ATCoordinates]::new($SampleAutomationCoords)

            $Sample.Row | Should -Be 40
            $Sample.Column | Should -Be 30
        }

        # It 'Should initialize as a copy of another ATCoordinates object' {
        #     [ATCoordinates]$SampleOriginal = [ATCoordinates]::new(55, 66)
        #     [ATCoordinates]$SampleCopy     = [ATCoordinates]::new($SampleOriginal)

        #     $SampleCopy.Row | Should -Be 55
        #     $SampleCopy.Column | Should -Be 66
        #     $SampleCopy | Should -Not -BeSameAs $SampleOriginal
        # }
    }

    Context 'Methods' {
        It 'ToAnsiControlSequenceString() should return the correct ANSI coordinate string' {
            [ATCoordinates]$Sample        = [ATCoordinates]::new(5, 15)
            [String]$ExpectedSampleResult = "`e[5;15H"
            [String]$ActualResult         = $Sample.ToAnsiControlSequenceString()

            $ActualResult | Should -Be $ExpectedSampleResult
        }

        It 'ToAutomationCoordinates() should return a correctly mapped Coordinates object' {
            [ATCoordinates]$Sample               = [ATCoordinates]::new(70, 80)
            [Coordinates]$SampleAutomationCoords = $Sample.ToAutomationCoordinates()

            $SampleAutomationCoords | Should -BeOfType ([Coordinates])
            $SampleAutomationCoords.X | Should -Be 80
            $SampleAutomationCoords.Y | Should -Be 70
        }
    }
}

