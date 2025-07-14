using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWITCHSBREWVIAL
#
###############################################################################

Class BEWitchsBrewVial : BEJewelry {
	BEWitchsBrewVial() : base() {
		$this.Name               = 'Witch''s Brew Vial'
		$this.MapObjName         = 'witchsbrewvial'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small vial containing a bubbling, potent brew.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Female
	}
}
