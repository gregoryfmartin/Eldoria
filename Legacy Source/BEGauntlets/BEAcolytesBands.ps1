using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEACOLYTESBANDS
#
###############################################################################

Class BEAcolytesBands : BEGauntlets {
	BEAcolytesBands() : base() {
		$this.Name               = 'Acolyte''s Bands'
		$this.MapObjName         = 'acolytesbands'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple bands for a magical apprentice, aiding their studies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
