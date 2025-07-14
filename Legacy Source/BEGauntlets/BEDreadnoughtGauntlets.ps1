using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREADNOUGHTGAUNTLETS
#
###############################################################################

Class BEDreadnoughtGauntlets : BEGauntlets {
	BEDreadnoughtGauntlets() : base() {
		$this.Name               = 'Dreadnought Gauntlets'
		$this.MapObjName         = 'dreadnoughtgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive, intimidating gauntlets for ultimate defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
