using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGHOSTPAULDRON
#
###############################################################################

Class BEGhostPauldron : BEPauldron {
	BEGhostPauldron() : base() {
		$this.Name               = 'Ghost Pauldron'
		$this.MapObjName         = 'ghostpauldron'
		$this.PurchasePrice      = 4950
		$this.SellPrice          = 2475
		$this.TargetStats        = @{
			[StatId]::Defense = 99
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by spectral beings, offering ethereal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
