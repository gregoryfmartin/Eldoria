using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANDROMEDACHARM
#
###############################################################################

Class BEAndromedaCharm : BEJewelry {
	BEAndromedaCharm() : base() {
		$this.Name               = 'Andromeda Charm'
		$this.MapObjName         = 'andromedacharm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Accuracy = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm depicting the Andromeda galaxy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
