using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASSASSINSPOISONVIAL
#
###############################################################################

Class BEAssassinsPoisonVial : BEJewelry {
	BEAssassinsPoisonVial() : base() {
		$this.Name               = 'Assassin''s Poison Vial'
		$this.MapObjName         = 'assassinspoisonvial'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny vial of potent, slow acting poison.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
