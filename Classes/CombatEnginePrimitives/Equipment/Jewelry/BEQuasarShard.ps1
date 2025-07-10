using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUASARSHARD
#
###############################################################################

Class BEQuasarShard : BEJewelry {
	BEQuasarShard() : base() {
		$this.Name               = 'Quasar Shard'
		$this.MapObjName         = 'quasarshard'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Attack = 3
			[StatId]::MagicAttack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard from a quasar, radiating immense energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
