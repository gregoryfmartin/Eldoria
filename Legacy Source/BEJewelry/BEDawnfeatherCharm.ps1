using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDAWNFEATHERCHARM
#
###############################################################################

Class BEDawnfeatherCharm : BEJewelry {
	BEDawnfeatherCharm() : base() {
		$this.Name               = 'Dawnfeather Charm'
		$this.MapObjName         = 'dawnfeathercharm'
		$this.PurchasePrice      = 870
		$this.SellPrice          = 435
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm with a feather from a bird that sings at dawn.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
