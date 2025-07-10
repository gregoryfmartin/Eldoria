using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARDENOFORDERPAULDRON
#
###############################################################################

Class BEWardenofOrderPauldron : BEPauldron {
	BEWardenofOrderPauldron() : base() {
		$this.Name               = 'Warden of Order Pauldron'
		$this.MapObjName         = 'wardenoforderpauldron'
		$this.PurchasePrice      = 10000
		$this.SellPrice          = 5000
		$this.TargetStats        = @{
			[StatId]::Defense = 200
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Upholds justice and maintains balance, with unwavering resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
