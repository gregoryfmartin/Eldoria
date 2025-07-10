using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDROWPAULDRON
#
###############################################################################

Class BEDrowPauldron : BEPauldron {
	BEDrowPauldron() : base() {
		$this.Name               = 'Drow Pauldron'
		$this.MapObjName         = 'drowpauldron'
		$this.PurchasePrice      = 5800
		$this.SellPrice          = 2900
		$this.TargetStats        = @{
			[StatId]::Defense = 116
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark and menacing, crafted by the drow of the underworld.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
