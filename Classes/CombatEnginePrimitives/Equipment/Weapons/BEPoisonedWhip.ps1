using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE POISONED WHIP
#
###############################################################################

Class BEPoisonedWhip : BEWeapon {
	BEPoisonedWhip() : base() {
		$this.Name          = 'Poisoned Whip'
		$this.MapObjName    = 'poisonedwhip'
		$this.PurchasePrice = 680
		$this.SellPrice     = 340
		$this.TargetStats   = @{
			[StatId]::Attack = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A whip with a barbed tip, coated in a fast-acting poison.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
