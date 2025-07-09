using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BLESSED CIRCLET
#
###############################################################################

Class BEBlessedCirclet : BEHelmet {
	BEBlessedCirclet() : base() {
		$this.Name               = 'Blessed Circlet'
		$this.MapObjName         = 'blessedcirclet'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple circlet blessed by a cleric, offering minor protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
