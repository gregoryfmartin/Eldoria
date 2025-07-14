using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYTHRILCIRCLET
#
###############################################################################

Class BEMythrilCirclet : BEJewelry {
	BEMythrilCirclet() : base() {
		$this.Name               = 'Mythril Circlet'
		$this.MapObjName         = 'mythrilcirclet'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering mythril circlet, for adept spellcasters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
