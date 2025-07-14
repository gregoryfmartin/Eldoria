using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTGREAVES
#
###############################################################################

Class BEDesertGreaves : BEGreaves {
	BEDesertGreaves() : base() {
		$this.Name               = 'Desert Greaves'
		$this.MapObjName         = 'desertgreaves'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves suitable for arid environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
