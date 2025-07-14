using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECENTURIONSLEGACYGAUNTLETS
#
###############################################################################

Class BECenturionsLegacyGauntlets : BEGauntlets {
	BECenturionsLegacyGauntlets() : base() {
		$this.Name               = 'Centurion''s Legacy Gauntlets'
		$this.MapObjName         = 'centurionslegacygauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a legendary centurion, carrying his might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
