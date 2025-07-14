using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAINPAULDRON
#
###############################################################################

Class BEChainPauldron : BEPauldron {
	BEChainPauldron() : base() {
		$this.Name               = 'Chain Pauldron'
		$this.MapObjName         = 'chainpauldron'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Interlocking metal rings form a flexible and protective pauldron.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
