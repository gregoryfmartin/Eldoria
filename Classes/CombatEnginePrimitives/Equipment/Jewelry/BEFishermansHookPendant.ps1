using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFISHERMANSHOOKPENDANT
#
###############################################################################

Class BEFishermansHookPendant : BEJewelry {
	BEFishermansHookPendant() : base() {
		$this.Name               = 'Fisherman''s Hook Pendant'
		$this.MapObjName         = 'fishermanshookpendant'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant shaped like a fish hook, for bountiful catches.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Male
	}
}
