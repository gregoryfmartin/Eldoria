using namespace System
using namespace System.Collections

Set-StrictMode -Version Latest

###############################################################################
#
# PLAYER ITEM INVENTORY
#
# LISTING IS DEFINED AS A HASHTABLE OF TYPE STRING, INT FOR THE KVP. THE KEYS
# ARE INTENDED TO BE THE MAP OBJECT NAMES OF MAPTILEOBJECTS
#
###############################################################################

Class PlayerItemInventory {
    [Hashtable]$Listing

    PlayerItemInventory() {
        $this.Listing = @{}
    }

    [Boolean]AddItem(
        [MapTileObject]$Item
    ) {
        If($this.Listing.ContainsKey($Item) -EQ $false) {
            $this.Listing[$Item] = 1

            Return $true
        }
        
        If($this.Listing[$Item] -GE 99) {
            Return $false
        }

        $this.Listing[$Item]++
        Return $true
    }

    [Boolean]AddItems(
        [MapTileObject]$Item,
        [Int]$Quantity
    ) {
        If($Quantity -LE 0) {
            Return $false
        }

        $CurrentQty = 0
        If($this.Listing.ContainsKey($Item)) {
            $CurrentQty = $this.Listing[$Item]
        }

        If(($CurrentQty + $Quantity) -GT 99) {
            Return $false
        }

        If($this.Listing.ContainsKey($Item) -EQ $false) {
            $this.Listing[$Item] = $Quantity
        } Else {
            $this.Listing[$Item] += $Quantity
        }

        Return $true
    }

    [ItemRemovalStatus]RemoveItem(
        [MapTileObject]$Item
    ) {
        If($this.Listing.ContainsKey($Item) -EQ $false) {
            Return [ItemRemovalStatus]::FailGeneral
        }

        If($Item.KeyItem) {
            Return [ItemRemovalStatus]::FailKeyItem
        }

        $this.Listing[$Item]--
        If($this.Listing[$Item] -LE 0) {
            $this.Listing.Remove($Item)
        }

        Return [ItemRemovalStatus]::Success
    }

    [ItemRemovalStatus]RemoveItems(
        [MapTileObject]$Item,
        [Int]$Quantity
    ) {
        If($this.Listing.ContainsKey($Item) -EQ $false) {
            Return [ItemRemovalStatus]::FailGeneral
        }

        If($Item.KeyItem) {
            Return [ItemRemovalStatus]::FailKeyItem
        }

        If($this.Listing[$Item] -LT $Quantity) {
            Return [ItemRemovalStatus]::FailGeneral
        }

        $this.Listing[$Item] -= $Quantity
        If($this.Listing[$Item] -LE 0) {
            $this.Listing.Remove($Item)
        }

        Return [ItemRemovalStatus]::Success
    }

    [Int]GetItemQuantity(
        [MapTileObject]$Item
    ) {
        If($this.Listing.ContainsKey($Item) -EQ $false) {
            Return 0
        }

        Return $this.Listing[$Item]
    }

    [Boolean]HasItem(
        [MapTileObject]$Item
    ) {
        Return $this.Listing.ContainsKey($Item)
    }

    [ArrayList]GetSortedItems() {
        $SortedItems = [ArrayList]::new()
        
        Foreach($Item in $this.Listing.GetEnumerator()) {
            $SortedItems.Add([PSCustomObject]@{
                Item     = $Item.Key
                Quantity = $Item.Value
            })
        }

        $SortedItems.Sort(
            {
                Param($A, $B) 
                
                $A.Item.Name.CompareTo($B.Item.Name)
            }
        )
        
        Return $SortedItems
    }
}
