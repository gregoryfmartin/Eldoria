using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPALADINPAULDRON
#
###############################################################################

Class BEPaladinPauldron : BEPauldron {
	BEPaladinPauldron() : base() {
		$this.Name               = 'Paladin Pauldron'
		$this.MapObjName         = 'paladinpauldron'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by holy warriors dedicated to justice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
