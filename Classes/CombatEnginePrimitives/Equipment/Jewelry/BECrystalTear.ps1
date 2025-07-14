using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALTEAR
#
###############################################################################

Class BECrystalTear : BEJewelry {
	BECrystalTear() : base() {
		$this.Name               = 'Crystal Tear'
		$this.MapObjName         = 'crystaltear'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A single, perfectly formed crystal tear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
