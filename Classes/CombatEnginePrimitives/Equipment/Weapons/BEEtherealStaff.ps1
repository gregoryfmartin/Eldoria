using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ETHEREAL STAFF
#
###############################################################################

Class BEEtherealStaff : BEWeapon {
	BEEtherealStaff() : base() {
		$this.Name          = 'Ethereal Staff'
		$this.MapObjName    = 'etherealstaff'
		$this.PurchasePrice = 4300
		$this.SellPrice     = 2150
		$this.TargetStats   = @{
			[StatId]::Attack      = 15
			[StatId]::MagicAttack = 110
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff made of pure arcane energy, granting mastery over magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
