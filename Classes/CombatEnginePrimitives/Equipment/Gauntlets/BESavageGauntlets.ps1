using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAVAGEGAUNTLETS
#
###############################################################################

Class BESavageGauntlets : BEGauntlets {
	BESavageGauntlets() : base() {
		$this.Name               = 'Savage Gauntlets'
		$this.MapObjName         = 'savagegauntlets'
		$this.PurchasePrice      = 470
		$this.SellPrice          = 235
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Brutal, unrefined gauntlets for savage warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
