using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETIMEBENDERCHRONOMETER
#
###############################################################################

Class BETimeBenderChronometer : BEJewelry {
	BETimeBenderChronometer() : base() {
		$this.Name               = 'Time Bender Chronometer'
		$this.MapObjName         = 'timebenderchronometer'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A complex chronometer, subtly altering the flow of time.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
