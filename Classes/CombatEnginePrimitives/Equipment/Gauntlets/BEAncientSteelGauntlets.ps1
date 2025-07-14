using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANCIENTSTEELGAUNTLETS
#
###############################################################################

Class BEAncientSteelGauntlets : BEGauntlets {
	BEAncientSteelGauntlets() : base() {
		$this.Name               = 'Ancient Steel Gauntlets'
		$this.MapObjName         = 'ancientsteelgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of incredibly old, resilient steel.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
