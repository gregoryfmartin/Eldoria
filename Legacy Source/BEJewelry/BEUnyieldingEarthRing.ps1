using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNYIELDINGEARTHRING
#
###############################################################################

Class BEUnyieldingEarthRing : BEJewelry {
	BEUnyieldingEarthRing() : base() {
		$this.Name               = 'Unyielding Earth Ring'
		$this.MapObjName         = 'unyieldingearthring'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring made of solid earth, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
