using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASHWOODGAUNTLETS
#
###############################################################################

Class BEAshwoodGauntlets : BEGauntlets {
	BEAshwoodGauntlets() : base() {
		$this.Name               = 'Ashwood Gauntlets'
		$this.MapObjName         = 'ashwoodgauntlets'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from ancient ashwood, light and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
