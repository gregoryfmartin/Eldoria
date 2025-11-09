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
    Static [Int]$QuantityMax = 99

    PlayerItemInventory() : base() {}
    
    [Int]IndexOfItem(
        [MapTileObject]$Item
    ) {
        For([Int]$I = 0; $I -LT $this.Count; $I++) {
            If($this[$I].Item1.MapObjName -EQ $Item.MapObjName) {
                Return $I
            }
        }
        
        Return -1
    }

    [Boolean]AddItem(
        [MapTileObject]$Item,
        [Int]$Qty = 1
    ) {
        [Int]$Tqty = 1

        If($Qty -GT [PlayerItemInventory]::QuantityMax) {
            $Tqty = [PlayerItemInventory]::QuantityMax
        } Else {
            $Tqty = $Qty
        }

        $Idx = $this.IndexOfItem($Item)
        
        If($Idx -GE 0) {
            $Temp = $this[$Idx]
            
            If(($Temp.Item2 + $Tqty) -GT [PlayerItemInventory]::QuantityMax) {
                $Temp.Item2 = [PlayerItemInventory]::QuantityMax
                $this[$Idx] = $Temp

                Return $true
            }
            
            $Temp.Item2 = $Temp.Item2 + $Tqty
            $this[$Idx] = $Temp
            
            Return $true
        } Else {
            $this.Add([ValueTuple[[MapTileObject], [Int]]]::new($Item, $Tqty))
            
            Return $true
        }
    }

    [ItemRemovalStatus]RemoveItem(
        [MapTileObject]$Item,
        [Int]$Qty = 1
    ) {
        $Idx = $this.IndexOfItem($Item)
        
        If($Idx -LT 0) {
            Return [ItemRemovalStatus]::FailGeneral
        }
        
        If($Item.KeyItem -EQ $true) {
            Return [ItemRemovalStatus]::FailKeyItem
        }
        
        $Temp   = $this[$Idx]
        $NewQty = $Temp.Item2 - $Qty
        
        If($NewQty -LE 0) {
            $this.RemoveAt($Idx)
        } Else {
            $Temp.Item2 = $NewQty
            $this[$Idx] = $Temp
        }
        
        Return [ItemRemovalStatus]::Success
    }
    
    [ItemRemovalStatus]RemoveAllItem(
        [MapTileObject]$Item
    ) {
        $Idx = $this.IndexOfItem($Item)
        
        If($Idx -LT 0) {
            Return [ItemRemovalStatus]::FailGeneral
        }
        
        If($Item.KeyItem -EQ $true) {
            Return [ItemRemovalStatus]::FailKeyItem
        }
        
        $this.RemoveAt($Idx)
        
        Return [ItemRemovalStatus]::Success
    }

    [Int]GetItemQuantity(
        [MapTileObject]$Item
    ) {
        $Idx = $this.IndexOfItem($Item)
        
        If($Idx -LT 0) {
            Return 0
        }
        
        Return $this[$Idx].Item2
    }
    
    [MapTileObject]GetItem(
        [String]$ItemName
    ) {
        If($this.HasItem($ItemName) -EQ $true) {
            Return $this.
        }
    }

    [Boolean]HasItem(
        [MapTileObject]$Item
    ) {
        Return ($this.IndexOfItem($Item) -GE 0)
    }
    
    [Boolean]HasItem(
        [String]$ItemName
    ) {
        Foreach($Item in $this) {
            If($Item.Item1.Name -EQ $ItemName) {
                Return $true
            }
        }
        
        Return $false
    }

    [ArrayList]GetSortedItems() {
        [ArrayList]$Al = [ArrayList]::new()
        
        $Projected = $this | ForEach-Object {
            [PSCustomObject]@{
                Item = $_.Item1
                Quantity = $_.Item2
            }
        } | Sort-Object { $_.Item.Name } -Descending
        
        [Void]$Al.AddRange($Projected)
        
        Return $Al
    }

    [Void]Sort() {
        $Sorted = $this | Sort-Object { $_.Item1.MapObjName }
        
        $this.Clear()
        
        Foreach($T in $Sorted) {
            [Void]$this.Add([ValueTuple[[MapTileObject], [Int]]]::new($T.Item1, $T.Item2))
        }
    }
}
