using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCANITESHARD
#
###############################################################################

Class BEArcaniteShard : BEJewelry {
	BEArcaniteShard() : base() {
		$this.Name               = 'Arcanite Shard'
		$this.MapObjName         = 'arcaniteshard'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering shard of pure arcanite.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
