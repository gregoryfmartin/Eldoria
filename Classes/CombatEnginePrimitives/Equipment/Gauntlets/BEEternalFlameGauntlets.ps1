using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETERNALFLAMEGAUNTLETS
#
###############################################################################

Class BEEternalFlameGauntlets : BEGauntlets {
	BEEternalFlameGauntlets() : base() {
		$this.Name               = 'Eternal Flame Gauntlets'
		$this.MapObjName         = 'eternalflamegauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets burning with a non-consuming flame.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
