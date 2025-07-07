using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE EQUIPMENT
#
###############################################################################

Class BattleEquipment : MapTileObject {    
    [Int]$PurchasePrice
    [Int]$SellPrice
    [Hashtable]$TargetStats
    [Hashtable]$RequiredStats
    [Gender]$TargetGender

    BattleEquipment() : base() {
        $this.PurchasePrice = 0
        $this.SellPrice     = 0
        $this.TargetStats   = @{}
        $this.RequiredStats = @{}
        $this.TargetGender  = [Gender]::Unisex
    }
}
