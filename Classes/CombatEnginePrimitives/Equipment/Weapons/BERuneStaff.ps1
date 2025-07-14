using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNESTAFF
#
###############################################################################

Class BERuneStaff : BEWeapon {
	BERuneStaff() : base() {
		$this.Name          = 'Rune Staff'
		$this.MapObjName    = 'runestaff'
		$this.PurchasePrice = 880
		$this.SellPrice     = 440
		$this.TargetStats   = @{
			[StatId]::Attack      = 8
			[StatId]::MagicAttack = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff inscribed with ancient runes, enhancing spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
