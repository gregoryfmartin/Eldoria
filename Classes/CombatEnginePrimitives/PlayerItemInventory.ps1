using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# PLAYER ITEM INVENTORY
#
###############################################################################

Class PlayerItemInventory {
    [List[MapTileObject]]$Listing

    [Boolean]IsItemInInventory(
        [String]$ItemName
    ) {
        Foreach($a in $this.Listing) {
            If($a.Name -IEQ $ItemName) {
                Return $true
            }
        }

        Return $false
    }

    [MapTileObject]GetItemReference(
        [String]$ItemName
    ) {
        Foreach($a in $this.Inventory) {
            If($a.Name -IEQ $ItemName) {
                Return $a
            }
        }

        Return $null
    }

    [ItemRemovalStatus]RemoveInventoryItemByName(
        [String]$ItemName
    ) {
        [Int]$c = 0

        Foreach($a in $this.Inventory) {
            If($a.Name -IEQ $ItemName) {
                If($a.KeyItem -EQ $true) {
                    Return [ItemRemovalStatus]::FailKeyItem
                }
                $this.Listing.RemoveAt($c)

                Return [ItemRemovalStatus]::Success
            }
            $c++
        }

        Return [ItemRemovalStatus]::FailGeneral
    }

    [ItemRemovalStatus]RemoveInventoryItemByIndex(
        [Int]$Index
    ) {
        [MapTileObject]$a = $null

        Try {
            $a = $this.Listing[$Index]
        } Catch {
            Return [ItemRemovalStatus]::FailGeneral
        }
        If($a.KeyItem -EQ $true) {
            Return [ItemRemovalStatus]::FailKeyItem
        }
        $this.Listing.RemoveAt($Index)

        Return [ItemRemovalStatus]::Success
    }
}
