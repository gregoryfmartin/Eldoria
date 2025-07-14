using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGALEPAULDRON
#
###############################################################################

Class BEGalePauldron : BEPauldron {
	BEGalePauldron() : base() {
		$this.Name               = 'Gale Pauldron'
		$this.MapObjName         = 'galepauldron'
		$this.PurchasePrice      = 3050
		$this.SellPrice          = 1525
		$this.TargetStats        = @{
			[StatId]::Defense = 61
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Channels the power of the wind, offering protection against air currents.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
