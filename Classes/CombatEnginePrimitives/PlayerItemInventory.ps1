using namespace System
using namespace System.Collections
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# PLAYER ITEM INVENTORY
#
# LISTING IS DEFINED AS A HASHTABLE OF TYPE STRING, INT FOR THE KVP. THE KEYS
# ARE INTENDED TO BE THE MAP OBJECT NAMES OF MAPTILEOBJECTS
#
###############################################################################

Class PlayerItemInventory : List[ValueTuple[[MapTileObject], [Int]]] {
    PlayerItemInventory() {}

    [Boolean]AddItem(
        [MapTileObject]$Item,
        [Int]$Qty = 1
    ) {
        $ExistingItem = $this | Where-Object { $_.Item1 -EQ $Item }

        If($ExistingItem) {
            If(($ExistingItem.Item2 + $Qty) -GT 99) {
                Return $false
            }
            $ExistingItem.Item2 += $Qty
        } Else {
            $this.Add([ValueTuple]::Create($Item, $Qty))
        }

        Return $true
    }

    [ItemRemovalStatus]RemoveItem(
        [MapTileObject]$Item,
        [Int]$Qty = 1
    ) {
        $ExistingItem = $this | Where-Object { $_.Item1 -EQ $Item }

        If($null -EQ $ExistingItem) {
            Return [ItemRemovalStatus]::FailGeneral
        }

        If($Item.KeyItem -EQ $true) {
            Return [ItemRemovalStatus]::FailKeyItem
        }

        $NewQty = $ExistingItem.Item2 - $Qty
        If($NewQty -LE 0) {
            $this.Remove($ExistingItem)
        } Else {
            $ExistingItem.Item2 = $NewQty
        }

        Return [ItemRemovalStatus]::Success
    }

    [Int]GetItemQuantity(
        [MapTileObject]$Item
    ) {
        $ExistingItem = $this | Where-Object { $_.Item1 -EQ $Item }

        If($null -EQ $ExistingItem) {
            Return 0
        }

        Return $ExistingItem.Item2
    }

    [Boolean]HasItem(
        [MapTileObject]$Item
    ) {
        $ExistingItem = $this | Where-Object { $_.Item1 -EQ $Item }

        Return ($null -NE $ExistingItem)
    }

    [ArrayList]GetSortedItems() {
        $SortedItems = [ArrayList]::new()

        Foreach($Item in $this) {
            $SortedItems.Add([PSCustomObject]@{
                Item     = $Item.Item1
                Quantity = $Item.Item2
            })
        }

        $SortedItems.Sort(
            {
                Param($A, $B)

                $B.Item.Name.CompareTo($A.Item.Name)
            }
        )

        Return $SortedItems
    }

    [Void]Sort() {
        $this.Sort(
            {
                Param($A, $B)

                $B.Item1.Name.CompareTo($A.Item1.Name)
            }
        )
    }
}
