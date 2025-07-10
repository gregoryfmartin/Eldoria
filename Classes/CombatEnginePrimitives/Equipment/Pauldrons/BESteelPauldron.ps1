using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEELPAULDRON
#
###############################################################################

Class BESteelPauldron : BEPauldron {
	BESteelPauldron() : base() {
		$this.Name               = 'Steel Pauldron'
		$this.MapObjName         = 'steelpauldron'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged from strong steel, a reliable choice for warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
