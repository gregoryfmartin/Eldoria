using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWANDOFTHEARCHMAGE
#
###############################################################################

Class BEWandoftheArchmage : BEWeapon {
	BEWandoftheArchmage() : base() {
		$this.Name          = 'Wand of the Archmage'
		$this.MapObjName    = 'wandofthearchmage'
		$this.PurchasePrice = 6800
		$this.SellPrice     = 3400
		$this.TargetStats   = @{
			[StatId]::Attack      = 55
			[StatId]::MagicAttack = 200
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wand of immense power, reserved for only the most skilled mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
