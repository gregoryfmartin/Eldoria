using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEICEBOUNDSHARD
#
###############################################################################

Class BEIceboundShard : BEJewelry {
	BEIceboundShard() : base() {
		$this.Name               = 'Icebound Shard'
		$this.MapObjName         = 'iceboundshard'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard of perpetually frozen ice, chilling to the touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
