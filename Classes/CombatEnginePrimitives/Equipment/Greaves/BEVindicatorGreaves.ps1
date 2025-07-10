using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVINDICATORGREAVES
#
###############################################################################

Class BEVindicatorGreaves : BEGreaves {
	BEVindicatorGreaves() : base() {
		$this.Name               = 'Vindicator Greaves'
		$this.MapObjName         = 'vindicatorgreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of justified defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
