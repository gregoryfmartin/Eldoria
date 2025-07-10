using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYRMSCALEVEST
#
###############################################################################

Class BEWyrmscaleVest : BEArmor {
	BEWyrmscaleVest() : base() {
		$this.Name               = 'Wyrmscale Vest'
		$this.MapObjName         = 'wyrmscalevest'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest crafted from the scales of a smaller wyrm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
