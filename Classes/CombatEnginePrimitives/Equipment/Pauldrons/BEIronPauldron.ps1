using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONPAULDRON
#
###############################################################################

Class BEIronPauldron : BEPauldron {
	BEIronPauldron() : base() {
		$this.Name               = 'Iron Pauldron'
		$this.MapObjName         = 'ironpauldron'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy iron pauldron, providing substantial physical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
