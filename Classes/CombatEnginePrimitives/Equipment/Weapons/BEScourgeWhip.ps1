using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCOURGEWHIP
#
###############################################################################

Class BEScourgeWhip : BEWeapon {
	BEScourgeWhip() : base() {
		$this.Name          = 'Scourge Whip'
		$this.MapObjName    = 'scourgewhip'
		$this.PurchasePrice = 700
		$this.SellPrice     = 350
		$this.TargetStats   = @{
			[StatId]::Attack      = 35
			[StatId]::MagicAttack = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A whip enchanted with dark magic, draining foes'' vitality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
