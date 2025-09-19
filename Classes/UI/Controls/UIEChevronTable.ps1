using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# UIECHEVRONTABLE
#
# A COLLECTION OF CHEVRONS IN FIXED POSITIONS. ONLY ONE CHEVRON CAN BE ACTIVE
# IN THIS COLLECTION.
#
###############################################################################

Class UIEChevronTable : List[ValueTuple[[UIEChevron], [Boolean]]] {
    [Int]$ActiveChevron

    UIEChevronTable() : base() {
        $this.ActiveChevron = 0
    }
    
    [Void]CreateChevrons(
        [Int]$NumChevrons,
        [PagingOrientation]$Orientation,
        [ATCoordinates]$StartCoords,
        [Int]$Step
    ) {
        If($NumChevrons -LE 0 -OR $Step -LE 0) {
            Return
        }
        
        Switch($Orientation) {
            ([PagingOrientation]::Horizontal) {
                $this.SetupHorizontalPaging($NumChevrons, $Step, $StartCoords); Break
            }
            
            ([PagingOrientation]::Vertical) {
                $this.SetupVerticalPaging($NumChevrons, $Step, $StartCoords); Break
            }
            
            Default {
                $this.SetupVerticalPaging($NumChevrons, $Step, $StartCoords); Break
            }
        }
    }
    
    [Void]SetupHorizontalPaging(
        [Int]$NumChevrons,
        [Int]$Step,
        [ATCoordinates]$StartCoords
    ) {
        For([Int]$A = 0; $A -LT $NumChevrons; $A++) {
            $this.Add([ValueTuple]::Create(
                [UIEChevron]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = ($A -EQ 0 ? $StartCoords.Row : $StartCoords.Row + $A + $Step)
                            Column = $StartCoords.Column
                        }
                    }
                    UserData = "$($A -EQ 0 ? [UIEChevron]::ChevronCharacter : ' ')"
                    UseATReset = $true
                },
                $false
            ))
        }
    }
    
    [Void]SetupVerticalPaging(
        [Int]$NumChevrons,
        [Int]$Step,
        [ATCoordinates]$StartCoords
    ) {
        For([Int]$A = 0; $A -LT $NumChevrons; $A++) {
            $this.Add([ValueTuple]::Create(
                [UIEChevron]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleVGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $StartCoords.Row
                            Column = ($A -EQ 0 ? $StartCoords.Column : $StartCoords.Column + $A + $Step)
                        }
                    }
                    UserData = "$($A -EQ 0 ? [UIEChevron]::ChevronCharacter : ' ')"
                    UseATReset = $true
                },
                $false
            ))
        }
    }
    
    [Void]ToAnsiControlSequenceString() {
        [String]$A = ''
        
        Foreach($Chevron in $this) {
            $A += "$($Chevron.ToAnsiControlSequenceString())"
        }
        
        Return "$($A)"
    }
    
    [Void]Draw() {
        If($this.Dirty -EQ $true) {
            Write-Host "$($this.ToAnsiControlSequenceString())"
            
            $this.Dirty = $false
        }
    }
}
