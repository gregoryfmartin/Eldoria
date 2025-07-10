using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFIREGAUNTLETS
#
###############################################################################

Class BEStarfireGauntlets : BEGauntlets {
	BEStarfireGauntlets() : base() {
		$this.Name               = 'Starfire Gauntlets'
		$this.MapObjName         = 'starfiregauntlets'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 115
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets glowing with cosmic fire, scorching foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
