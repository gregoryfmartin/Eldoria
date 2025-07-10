using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPARKLIGHTCIRCLET
#
###############################################################################

Class BESparklightCirclet : BEJewelry {
	BESparklightCirclet() : base() {
		$this.Name               = 'Sparklight Circlet'
		$this.MapObjName         = 'sparklightcirclet'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that emits tiny, harmless sparks of light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Female
	}
}
