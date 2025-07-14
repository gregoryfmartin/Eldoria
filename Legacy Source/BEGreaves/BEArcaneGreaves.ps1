using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCANEGREAVES
#
###############################################################################

Class BEArcaneGreaves : BEGreaves {
	BEArcaneGreaves() : base() {
		$this.Name               = 'Arcane Greaves'
		$this.MapObjName         = 'arcanegreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves infused with raw arcane power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
