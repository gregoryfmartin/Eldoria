using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECENTURIONGAUNTLETS
#
###############################################################################

Class BECenturionGauntlets : BEGauntlets {
	BECenturionGauntlets() : base() {
		$this.Name               = 'Centurion Gauntlets'
		$this.MapObjName         = 'centuriongauntlets'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, practical gauntlets for a seasoned soldier.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
