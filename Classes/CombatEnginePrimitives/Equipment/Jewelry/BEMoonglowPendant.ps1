using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONGLOWPENDANT
#
###############################################################################

Class BEMoonglowPendant : BEJewelry {
	BEMoonglowPendant() : base() {
		$this.Name               = 'Moonglow Pendant'
		$this.MapObjName         = 'moonglowpendant'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant that emits a soft, ethereal glow.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
