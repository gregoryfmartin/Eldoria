using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPELEOLOGISTGREAVES
#
###############################################################################

Class BESpeleologistGreaves : BEGreaves {
	BESpeleologistGreaves() : base() {
		$this.Name               = 'Speleologist Greaves'
		$this.MapObjName         = 'speleologistgreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for cave explorers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
