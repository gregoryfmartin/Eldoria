using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETEMPLARGREAVES
#
###############################################################################

Class BETemplarGreaves : BEGreaves {
	BETemplarGreaves() : base() {
		$this.Name               = 'Templar Greaves'
		$this.MapObjName         = 'templargreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Holy greaves worn by zealous protectors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
