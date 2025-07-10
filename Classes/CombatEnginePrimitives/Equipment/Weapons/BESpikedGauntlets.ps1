using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIKEDGAUNTLETS
#
###############################################################################

Class BESpikedGauntlets : BEWeapon {
	BESpikedGauntlets() : base() {
		$this.Name          = 'Spiked Gauntlets'
		$this.MapObjName    = 'spikedgauntlets'
		$this.PurchasePrice = 850
		$this.SellPrice     = 425
		$this.TargetStats   = @{
			[StatId]::Attack = 51
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy gauntlets with protruding spikes, ideal for brutal close combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
