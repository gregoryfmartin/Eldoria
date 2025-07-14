using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBOUNDLESSAIRCIRCLET
#
###############################################################################

Class BEBoundlessAirCirclet : BEJewelry {
	BEBoundlessAirCirclet() : base() {
		$this.Name               = 'Boundless Air Circlet'
		$this.MapObjName         = 'boundlessaircirclet'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that allows the wearer to breathe freely.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
