using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLESSEDSILVERGAUNTLETS
#
###############################################################################

Class BEBlessedSilverGauntlets : BEGauntlets {
	BEBlessedSilverGauntlets() : base() {
		$this.Name               = 'Blessed Silver Gauntlets'
		$this.MapObjName         = 'blessedsilvergauntlets'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of purified silver, effective against undead.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
