using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDHEARTGAUNTLETS
#
###############################################################################

Class BEVoidHeartGauntlets : BEGauntlets {
	BEVoidHeartGauntlets() : base() {
		$this.Name               = 'Void Heart Gauntlets'
		$this.MapObjName         = 'voidheartgauntlets'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that house a fragment of the void, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
