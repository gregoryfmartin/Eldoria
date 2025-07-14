using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPLATEGREAVES
#
###############################################################################

Class BEPlateGreaves : BEGreaves {
	BEPlateGreaves() : base() {
		$this.Name               = 'Plate Greaves'
		$this.MapObjName         = 'plategreaves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Full plate leg armor, excellent protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
