using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBERSERKERGREAVES
#
###############################################################################

Class BEBerserkerGreaves : BEGreaves {
	BEBerserkerGreaves() : base() {
		$this.Name               = 'Berserker Greaves'
		$this.MapObjName         = 'berserkergreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for those who fight with unrestrained fury.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
