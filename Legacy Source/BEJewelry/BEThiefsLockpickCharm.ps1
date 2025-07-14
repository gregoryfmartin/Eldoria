using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHIEFSLOCKPICKCHARM
#
###############################################################################

Class BEThiefsLockpickCharm : BEJewelry {
	BEThiefsLockpickCharm() : base() {
		$this.Name               = 'Thief''s Lockpick Charm'
		$this.MapObjName         = 'thiefslockpickcharm'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm resembling a tiny lockpick, for nimble fingers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
