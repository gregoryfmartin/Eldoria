using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPALADINGREAVES
#
###############################################################################

Class BEPaladinGreaves : BEGreaves {
	BEPaladinGreaves() : base() {
		$this.Name               = 'Paladin Greaves'
		$this.MapObjName         = 'paladingreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a holy warrior, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
