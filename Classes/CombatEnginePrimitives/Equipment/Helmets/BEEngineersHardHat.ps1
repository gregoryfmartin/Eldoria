using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ENGINEER'S HARD HAT
#
###############################################################################

Class BEEngineersHardHat : BEHelmet {
	BEEngineersHardHat() : base() {
		$this.Name               = 'Engineer''s Hard Hat'
		$this.MapObjName         = 'engineershardhat'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A durable hard hat worn by engineers, providing protection in hazardous environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
