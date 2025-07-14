using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCALEMAILGAUNTLETS
#
###############################################################################

Class BEScaleMailGauntlets : BEGauntlets {
	BEScaleMailGauntlets() : base() {
		$this.Name               = 'Scale Mail Gauntlets'
		$this.MapObjName         = 'scalemailgauntlets'
		$this.PurchasePrice      = 240
		$this.SellPrice          = 120
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets composed of overlapping metal scales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
