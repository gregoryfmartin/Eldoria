using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZOOLOGISTGREAVES
#
###############################################################################

Class BEZoologistGreaves : BEGreaves {
	BEZoologistGreaves() : base() {
		$this.Name               = 'Zoologist Greaves'
		$this.MapObjName         = 'zoologistgreaves'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for animal researchers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
