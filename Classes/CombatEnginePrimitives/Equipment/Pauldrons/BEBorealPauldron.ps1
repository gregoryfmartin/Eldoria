using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBOREALPAULDRON
#
###############################################################################

Class BEBorealPauldron : BEPauldron {
	BEBorealPauldron() : base() {
		$this.Name               = 'Boreal Pauldron'
		$this.MapObjName         = 'borealpauldron'
		$this.PurchasePrice      = 3800
		$this.SellPrice          = 1900
		$this.TargetStats        = @{
			[StatId]::Defense = 76
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Woven with threads of ice, offering chilling protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
