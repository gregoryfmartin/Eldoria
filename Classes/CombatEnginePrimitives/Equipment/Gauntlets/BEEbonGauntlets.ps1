using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEBONGAUNTLETS
#
###############################################################################

Class BEEbonGauntlets : BEGauntlets {
	BEEbonGauntlets() : base() {
		$this.Name               = 'Ebon Gauntlets'
		$this.MapObjName         = 'ebongauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged from solidified darkness, absorbing all light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
