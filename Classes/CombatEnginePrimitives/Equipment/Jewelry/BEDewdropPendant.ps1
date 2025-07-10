using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEWDROPPENDANT
#
###############################################################################

Class BEDewdropPendant : BEJewelry {
	BEDewdropPendant() : base() {
		$this.Name               = 'Dewdrop Pendant'
		$this.MapObjName         = 'dewdroppendant'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant with a perpetual dewdrop, refreshing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
