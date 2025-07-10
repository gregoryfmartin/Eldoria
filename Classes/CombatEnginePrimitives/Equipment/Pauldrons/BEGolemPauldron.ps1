using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMPAULDRON
#
###############################################################################

Class BEGolemPauldron : BEPauldron {
	BEGolemPauldron() : base() {
		$this.Name               = 'Golem Pauldron'
		$this.MapObjName         = 'golempauldron'
		$this.PurchasePrice      = 3400
		$this.SellPrice          = 1700
		$this.TargetStats        = @{
			[StatId]::Defense = 68
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Imbued with the spirit of a golem, unmoving and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
