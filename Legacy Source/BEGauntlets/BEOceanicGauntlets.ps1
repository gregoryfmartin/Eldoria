using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOCEANICGAUNTLETS
#
###############################################################################

Class BEOceanicGauntlets : BEGauntlets {
	BEOceanicGauntlets() : base() {
		$this.Name               = 'Oceanic Gauntlets'
		$this.MapObjName         = 'oceanicgauntlets'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets smelling of the sea, aiding in water spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
