using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPUNISHERGREAVES
#
###############################################################################

Class BEPunisherGreaves : BEGreaves {
	BEPunisherGreaves() : base() {
		$this.Name               = 'Punisher Greaves'
		$this.MapObjName         = 'punishergreaves'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of relentless retribution.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
