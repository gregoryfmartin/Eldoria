using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAURORABOREALISGEM
#
###############################################################################

Class BEAuroraBorealisGem : BEJewelry {
	BEAuroraBorealisGem() : base() {
		$this.Name               = 'Aurora Borealis Gem'
		$this.MapObjName         = 'auroraborealisgem'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that shimmers with the colors of the aurora.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
