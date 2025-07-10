using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFERNALGREAVES
#
###############################################################################

Class BEInfernalGreaves : BEGreaves {
	BEInfernalGreaves() : base() {
		$this.Name               = 'Infernal Greaves'
		$this.MapObjName         = 'infernalgreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves forged in the fires of hell.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
