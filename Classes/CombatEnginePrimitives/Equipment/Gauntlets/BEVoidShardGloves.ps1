using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSHARDGLOVES
#
###############################################################################

Class BEVoidShardGloves : BEGauntlets {
	BEVoidShardGloves() : base() {
		$this.Name               = 'Void Shard Gloves'
		$this.MapObjName         = 'voidshardgloves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves containing fragments of the void, disorienting foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
