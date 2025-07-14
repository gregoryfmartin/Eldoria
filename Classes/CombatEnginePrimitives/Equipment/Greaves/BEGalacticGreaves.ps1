using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGALACTICGREAVES
#
###############################################################################

Class BEGalacticGreaves : BEGreaves {
	BEGalacticGreaves() : base() {
		$this.Name               = 'Galactic Greaves'
		$this.MapObjName         = 'galacticgreaves'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 58
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves from beyond the galaxy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
