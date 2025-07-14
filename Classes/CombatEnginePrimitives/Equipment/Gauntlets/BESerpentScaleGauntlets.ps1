using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERPENTSCALEGAUNTLETS
#
###############################################################################

Class BESerpentScaleGauntlets : BEGauntlets {
	BESerpentScaleGauntlets() : base() {
		$this.Name               = 'Serpent Scale Gauntlets'
		$this.MapObjName         = 'serpentscalegauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from large serpent scales, flexible and tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
