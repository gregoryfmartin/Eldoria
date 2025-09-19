using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# STATUS ITEM INVENTORY CONTEXT DIALOG
#
# A SMALL TWO-ITEM DIALOG WITH "USE" AND "DROP" OPTIONS.
#
###############################################################################

Class StatusItemInventoryContextDialog : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 1
    Static [Int]$WindowRBColumn = 1

    Static [String[]]$OptionsData = @(
        'Use',
        'Drop'
    )
    Static [String]$ChevronCharacterData      = '❱'
    Static [String]$ChevronCharacterBlankData = ' '

    [Boolean]$PlayerChevronDirty
    [Boolean]$OptionsListDirty

    [Int]$ActiveChevronIndex

    [List[ATString]]$OptionsActual
    [List[ValueTuple[[ATString], [Boolean]]]]$ChevronsActual

    StatusItemInventoryContextDialog() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusItemInventoryContextDialog]::WindowLTRow
            Column = [StatusItemInventoryContextDialog]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusItemInventoryContextDialog]::WindowRBRow
            Column = [StatusItemInventoryContextDialog]::WindowRBColumn
        }

        $this.UpdateDimensions()
    }
}