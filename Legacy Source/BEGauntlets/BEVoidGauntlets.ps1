using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDGAUNTLETS
#
###############################################################################

Class BEVoidGauntlets : BEGauntlets {
	BEVoidGauntlets() : base() {
		$this.Name               = 'Void Gauntlets'
		$this.MapObjName         = 'voidgauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from the void, absorbing magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
