using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIMENSIONSHIFTER
#
###############################################################################

Class BEDimensionShifter : BEJewelry {
	BEDimensionShifter() : base() {
		$this.Name               = 'Dimension Shifter'
		$this.MapObjName         = 'dimensionshifter'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Speed = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small device that can momentarily shift dimensions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
