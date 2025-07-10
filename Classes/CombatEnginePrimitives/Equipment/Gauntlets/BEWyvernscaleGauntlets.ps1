using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYVERNSCALEGAUNTLETS
#
###############################################################################

Class BEWyvernscaleGauntlets : BEGauntlets {
	BEWyvernscaleGauntlets() : base() {
		$this.Name               = 'Wyvernscale Gauntlets'
		$this.MapObjName         = 'wyvernscalegauntlets'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from the scales of a full-grown wyvern.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
