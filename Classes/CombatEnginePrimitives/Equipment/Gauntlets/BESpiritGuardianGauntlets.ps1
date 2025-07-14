using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITGUARDIANGAUNTLETS
#
###############################################################################

Class BESpiritGuardianGauntlets : BEGauntlets {
	BESpiritGuardianGauntlets() : base() {
		$this.Name               = 'Spirit Guardian Gauntlets'
		$this.MapObjName         = 'spiritguardiangauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with ancient guardian spirits, protecting all.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
