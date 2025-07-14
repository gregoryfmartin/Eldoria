using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVISIONARYPAULDRON
#
###############################################################################

Class BEVisionaryPauldron : BEPauldron {
	BEVisionaryPauldron() : base() {
		$this.Name               = 'Visionary Pauldron'
		$this.MapObjName         = 'visionarypauldron'
		$this.PurchasePrice      = 7550
		$this.SellPrice          = 3775
		$this.TargetStats        = @{
			[StatId]::Defense = 151
			[StatId]::MagicDefense = 72
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Inspires allies and reveals weaknesses in enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
