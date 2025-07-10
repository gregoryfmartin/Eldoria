using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIONHEARTGAUNTLETS
#
###############################################################################

Class BELionheartGauntlets : BEGauntlets {
	BELionheartGauntlets() : base() {
		$this.Name               = 'Lionheart Gauntlets'
		$this.MapObjName         = 'lionheartgauntlets'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets bearing the symbol of a lion, inspiring courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
