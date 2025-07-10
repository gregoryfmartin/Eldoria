using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVANGUARDGREAVES
#
###############################################################################

Class BEVanguardGreaves : BEGreaves {
	BEVanguardGreaves() : base() {
		$this.Name               = 'Vanguard Greaves'
		$this.MapObjName         = 'vanguardgreaves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for the front lines of battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
