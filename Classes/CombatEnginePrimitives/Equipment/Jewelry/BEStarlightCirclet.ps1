using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARLIGHTCIRCLET
#
###############################################################################

Class BEStarlightCirclet : BEJewelry {
	BEStarlightCirclet() : base() {
		$this.Name               = 'Starlight Circlet'
		$this.MapObjName         = 'starlightcirclet'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that seems to gather starlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
