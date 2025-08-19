using namespace System.Management.Automation.Host

Describe 'ATCoordinatesNone' {
    BeforeAll {
        . $PSScriptRoot\..\Classes\ATStrings\ATControlSequences.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATCoordinates.ps1
        . $PSScriptRoot\..\Classes\ATStrings\ATCoordinatesNone.ps1
    }

    Context 'Constructor' {
        It 'Should initialize with Row and Column set to 0' {
            [ATCoordinatesNone]$Sample = [ATCoordinatesNone]::new()

            $Sample.Row | Should -Be 0
            $Sample.Column | Should -Be 0
        }
    }

    Context 'Methods' {
        It 'ToAnsiControlSequenceString() should return an empty string' {
            [ATCoordinatesNone]$Sample = [ATCoordinatesNone]::new()
            [String]$SampleResult      = $Sample.ToAnsiControlSequenceString()

            $SampleResult | Should -Be ''
        }

        It 'ToAutomationCoordinates() should return a Coordinates object with X=0, Y=0' {
            [ATCoordinatesNone]$Sample           = [ATCoordinatesNone]::new()
            [Coordinates]$SampleAutomationCoords = $Sample.ToAutomationCoordinates()

            $SampleAutomationCoords.X | Should -Be 0
            $SampleAutomationCoords.Y | Should -Be 0
        }
    }
}

