using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDAYBREAKPENDANT
#
###############################################################################

Class BEDaybreakPendant : BEJewelry {
	BEDaybreakPendant() : base() {
		$this.Name               = 'Daybreak Pendant'
		$this.MapObjName         = 'daybreakpendant'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant that always seems to catch the first rays of dawn.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
