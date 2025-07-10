using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMALACHITERING
#
###############################################################################

Class BEMalachiteRing : BEJewelry {
	BEMalachiteRing() : base() {
		$this.Name               = 'Malachite Ring'
		$this.MapObjName         = 'malachitering'
		$this.PurchasePrice      = 490
		$this.SellPrice          = 245
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A patterned malachite ring, for grounding energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
