using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERKILLERGREAVES
#
###############################################################################

Class BEHunterKillerGreaves : BEGreaves {
	BEHunterKillerGreaves() : base() {
		$this.Name               = 'Hunter Killer Greaves'
		$this.MapObjName         = 'hunterkillergreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves designed for tracking and eliminating targets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
