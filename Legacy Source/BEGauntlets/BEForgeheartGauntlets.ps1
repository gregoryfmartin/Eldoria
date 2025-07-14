using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORGEHEARTGAUNTLETS
#
###############################################################################

Class BEForgeheartGauntlets : BEGauntlets {
	BEForgeheartGauntlets() : base() {
		$this.Name               = 'Forgeheart Gauntlets'
		$this.MapObjName         = 'forgeheartgauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from a master smith''s forge, enduring and hot.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
