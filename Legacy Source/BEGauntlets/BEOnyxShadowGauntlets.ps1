using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEONYXSHADOWGAUNTLETS
#
###############################################################################

Class BEOnyxShadowGauntlets : BEGauntlets {
	BEOnyxShadowGauntlets() : base() {
		$this.Name               = 'Onyx Shadow Gauntlets'
		$this.MapObjName         = 'onyxshadowgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of pure shadow, absorbing all light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
