using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLOOMGAUNTLETS
#
###############################################################################

Class BEGloomGauntlets : BEGauntlets {
	BEGloomGauntlets() : base() {
		$this.Name               = 'Gloom Gauntlets'
		$this.MapObjName         = 'gloomgauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to absorb light and hope.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
