using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWORLDSHAPERGAUNTLETS
#
###############################################################################

Class BEWorldshaperGauntlets : BEGauntlets {
	BEWorldshaperGauntlets() : base() {
		$this.Name               = 'Worldshaper Gauntlets'
		$this.MapObjName         = 'worldshapergauntlets'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::Defense = 130
			[StatId]::MagicDefense = 65
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that hum with world-shaping energy, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
