using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITESSENCE
#
###############################################################################

Class BESpiritEssence : BEJewelry {
	BESpiritEssence() : base() {
		$this.Name               = 'Spirit Essence'
		$this.MapObjName         = 'spiritessence'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vial containing a concentrated spirit essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
