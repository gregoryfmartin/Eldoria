using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWIZARDSSTAFF
#
###############################################################################

Class BEWizardsStaff : BEWeapon {
	BEWizardsStaff() : base() {
		$this.Name          = 'Wizard''s Staff'
		$this.MapObjName    = 'wizardsstaff'
		$this.PurchasePrice = 850
		$this.SellPrice     = 425
		$this.TargetStats   = @{
			[StatId]::Attack      = 10
			[StatId]::MagicAttack = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff crackling with magical energy, favored by powerful mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
