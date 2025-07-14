using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPRACTICESTAFF
#
###############################################################################

Class BEPracticeStaff : BEWeapon {
	BEPracticeStaff() : base() {
		$this.Name          = 'Practice Staff'
		$this.MapObjName    = 'practicestaff'
		$this.PurchasePrice = 80
		$this.SellPrice     = 40
		$this.TargetStats   = @{
			[StatId]::Attack      = 1
			[StatId]::MagicAttack = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight staff designed for training.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
