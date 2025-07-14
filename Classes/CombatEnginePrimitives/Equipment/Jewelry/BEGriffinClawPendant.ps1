using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIFFINCLAWPENDANT
#
###############################################################################

Class BEGriffinClawPendant : BEJewelry {
	BEGriffinClawPendant() : base() {
		$this.Name               = 'Griffin Claw Pendant'
		$this.MapObjName         = 'griffinclawpendant'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 1
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fierce griffin claw pendant, enhancing predatory instincts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}
