using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSHARDGLOVESIII
#
###############################################################################

Class BEVoidShardGlovesIII : BEGauntlets {
	BEVoidShardGlovesIII() : base() {
		$this.Name               = 'Void Shard Gloves III'
		$this.MapObjName         = 'voidshardglovesiii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 58
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Void Shard Gloves, supreme disorientation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
