using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETERNALFLAMEGAUNTLETSII
#
###############################################################################

Class BEEternalFlameGauntletsII : BEGauntlets {
	BEEternalFlameGauntletsII() : base() {
		$this.Name               = 'Eternal Flame Gauntlets II'
		$this.MapObjName         = 'eternalflamegauntletsii'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Stronger Eternal Flame Gauntlets, more intense heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
