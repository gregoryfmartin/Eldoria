using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCTICGREAVES
#
###############################################################################

Class BEArcticGreaves : BEGreaves {
	BEArcticGreaves() : base() {
		$this.Name               = 'Arctic Greaves'
		$this.MapObjName         = 'arcticgreaves'
		$this.PurchasePrice      = 470
		$this.SellPrice          = 235
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves designed for cold climates.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
