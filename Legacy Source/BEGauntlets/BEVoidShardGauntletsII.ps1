using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSHARDGAUNTLETSII
#
###############################################################################

Class BEVoidShardGauntletsII : BEGauntlets {
	BEVoidShardGauntletsII() : base() {
		$this.Name               = 'Void Shard Gauntlets II'
		$this.MapObjName         = 'voidshardgauntletsii'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Void Shard Gauntlets, stronger disorientation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
