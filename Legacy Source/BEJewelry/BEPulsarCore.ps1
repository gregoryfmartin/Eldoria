using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPULSARCORE
#
###############################################################################

Class BEPulsarCore : BEJewelry {
	BEPulsarCore() : base() {
		$this.Name               = 'Pulsar Core'
		$this.MapObjName         = 'pulsarcore'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rapidly spinning core, generating powerful magnetic fields.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
