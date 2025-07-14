using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFLESHGOLEMVEST
#
###############################################################################

Class BEFleshGolemVest : BEArmor {
	BEFleshGolemVest() : base() {
		$this.Name               = 'Flesh Golem Vest'
		$this.MapObjName         = 'fleshgolemvest'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A repulsive vest made from stitched together flesh, surprisingly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
