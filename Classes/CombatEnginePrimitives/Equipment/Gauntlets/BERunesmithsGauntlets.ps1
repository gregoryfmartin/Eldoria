using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNESMITHSGAUNTLETS
#
###############################################################################

Class BERunesmithsGauntlets : BEGauntlets {
	BERunesmithsGauntlets() : base() {
		$this.Name               = 'Runesmith''s Gauntlets'
		$this.MapObjName         = 'runesmithsgauntlets'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Defense = 36
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets inscribed with powerful runes, enhancing craftsmanship and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
