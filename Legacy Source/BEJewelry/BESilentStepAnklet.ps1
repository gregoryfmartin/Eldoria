using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILENTSTEPANKLET
#
###############################################################################

Class BESilentStepAnklet : BEJewelry {
	BESilentStepAnklet() : base() {
		$this.Name               = 'Silent Step Anklet'
		$this.MapObjName         = 'silentstepanklet'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An anklet that muffles footsteps, for stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
