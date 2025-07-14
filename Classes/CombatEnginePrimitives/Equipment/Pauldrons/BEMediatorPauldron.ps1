using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMEDIATORPAULDRON
#
###############################################################################

Class BEMediatorPauldron : BEPauldron {
	BEMediatorPauldron() : base() {
		$this.Name               = 'Mediator Pauldron'
		$this.MapObjName         = 'mediatorpauldron'
		$this.PurchasePrice      = 9900
		$this.SellPrice          = 4950
		$this.TargetStats        = @{
			[StatId]::Defense = 198
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Promotes understanding and de-escalation in conflicts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
