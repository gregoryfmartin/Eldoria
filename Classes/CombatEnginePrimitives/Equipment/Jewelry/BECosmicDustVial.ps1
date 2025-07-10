using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICDUSTVIAL
#
###############################################################################

Class BECosmicDustVial : BEJewelry {
	BECosmicDustVial() : base() {
		$this.Name               = 'Cosmic Dust Vial'
		$this.MapObjName         = 'cosmicdustvial'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vial filled with shimmering cosmic dust.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
