using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETEMPESTTEAR
#
###############################################################################

Class BETempestTear : BEJewelry {
	BETempestTear() : base() {
		$this.Name               = 'Tempest Tear'
		$this.MapObjName         = 'tempesttear'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A solidified tear from a storm, granting control over wind.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
