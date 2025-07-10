using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDANCERSRIBBON
#
###############################################################################

Class BEDancersRibbon : BEJewelry {
	BEDancersRibbon() : base() {
		$this.Name               = 'Dancer''s Ribbon'
		$this.MapObjName         = 'dancersribbon'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate ribbon that flows gracefully.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
