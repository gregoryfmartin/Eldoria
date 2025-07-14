using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMERALDSCALEGAUNTLETS
#
###############################################################################

Class BEEmeraldScaleGauntlets : BEGauntlets {
	BEEmeraldScaleGauntlets() : base() {
		$this.Name               = 'Emerald Scale Gauntlets'
		$this.MapObjName         = 'emeraldscalegauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from vibrant green dragon scales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
