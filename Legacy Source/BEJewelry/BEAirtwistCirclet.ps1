using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAIRTWISTCIRCLET
#
###############################################################################

Class BEAirtwistCirclet : BEJewelry {
	BEAirtwistCirclet() : base() {
		$this.Name               = 'Airtwist Circlet'
		$this.MapObjName         = 'airtwistcirclet'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light circlet that allows the wearer to feel air currents.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
