using namespace System.Management.Automation.Host

# This assumes your test runner can locate and load these class files.
# If running this file directly, you would need something like:
# . (Join-Path $PSScriptRoot '..\..\..\Classes\ATStrings\ATControlSequences.ps1')
# . (Join-Path $PSScriptRoot '..\..\..\Classes\ATStrings\ATCoordinates.ps1')
# . (Join-Path $PSScriptRoot '..\..\..\Classes\ATStrings\ATCoordinatesDefault.ps1')

Describe 'ATCoordinatesDefault' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATCoordinates.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATCoordinatesDefault.ps1
    }

    Context 'Constructor' {
        It 'Should initialize with the correct default values (Row=18, Column=2)' {
            [ATCoordinatesDefault]$Sample = [ATCoordinatesDefault]::new()

            $Sample.Row | Should -Be 18
            $Sample.Column | Should -Be 2
        }
    }

    Context 'Inherited Methods' {
        It 'ToAnsiControlSequenceString() should return the correct ANSI string for the default coordinates' {
            [ATCoordinatesDefault]$Sample = [ATCoordinatesDefault]::new()
            [String]$ExpectedResult       = "`e[18;2H"

            $Sample.ToAnsiControlSequenceString() | Should -Be $ExpectedResult
        }

        It 'ToAutomationCoordinates() should return a correctly mapped Coordinates object' {
            [ATCoordinatesDefault]$Sample        = [ATCoordinatesDefault]::new()
            [Coordinates]$SampleAutomationCoords = $Sample.ToAutomationCoordinates()

            $SampleAutomationCoords.X | Should -Be 2
            $SampleAutomationCoords.Y | Should -Be 18
        }
    }
}

