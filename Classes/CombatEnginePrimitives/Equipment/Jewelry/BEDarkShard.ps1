using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDARKSHARD
#
###############################################################################

Class BEDarkShard : BEJewelry {
	BEDarkShard() : base() {
		$this.Name               = 'Dark Shard'
		$this.MapObjName         = 'darkshard'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A jagged dark shard, filled with malevolence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
