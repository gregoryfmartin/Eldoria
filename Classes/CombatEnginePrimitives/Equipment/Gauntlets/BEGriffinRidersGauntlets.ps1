using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIFFINRIDERSGAUNTLETS
#
###############################################################################

Class BEGriffinRidersGauntlets : BEGauntlets {
	BEGriffinRidersGauntlets() : base() {
		$this.Name               = 'Griffin Rider''s Gauntlets'
		$this.MapObjName         = 'griffinridersgauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Aerodynamic gauntlets for those who ride the skies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
