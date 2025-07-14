using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBONEPLATEDGAUNTLETS
#
###############################################################################

Class BEBonePlatedGauntlets : BEGauntlets {
	BEBonePlatedGauntlets() : base() {
		$this.Name               = 'Bone-Plated Gauntlets'
		$this.MapObjName         = 'boneplatedgauntlets'
		$this.PurchasePrice      = 210
		$this.SellPrice          = 105
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from hardened animal bones.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
