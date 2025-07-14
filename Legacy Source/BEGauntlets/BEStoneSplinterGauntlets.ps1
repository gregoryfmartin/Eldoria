using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONESPLINTERGAUNTLETS
#
###############################################################################

Class BEStoneSplinterGauntlets : BEGauntlets {
	BEStoneSplinterGauntlets() : base() {
		$this.Name               = 'Stone Splinter Gauntlets'
		$this.MapObjName         = 'stonesplintergauntlets'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets reinforced with sharp stone splinters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
