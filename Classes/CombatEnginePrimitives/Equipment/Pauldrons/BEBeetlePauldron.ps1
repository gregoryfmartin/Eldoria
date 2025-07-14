using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEETLEPAULDRON
#
###############################################################################

Class BEBeetlePauldron : BEPauldron {
	BEBeetlePauldron() : base() {
		$this.Name               = 'Beetle Pauldron'
		$this.MapObjName         = 'beetlepauldron'
		$this.PurchasePrice      = 5600
		$this.SellPrice          = 2800
		$this.TargetStats        = @{
			[StatId]::Defense = 112
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Hardened carapace provides exceptional defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
