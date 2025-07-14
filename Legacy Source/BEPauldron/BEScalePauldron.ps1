using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCALEPAULDRON
#
###############################################################################

Class BEScalePauldron : BEPauldron {
	BEScalePauldron() : base() {
		$this.Name               = 'Scale Pauldron'
		$this.MapObjName         = 'scalepauldron'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Overlapping metal scales provide good defense against various attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
