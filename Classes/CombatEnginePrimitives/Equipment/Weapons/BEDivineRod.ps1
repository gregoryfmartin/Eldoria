using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEROD
#
###############################################################################

Class BEDivineRod : BEWeapon {
	BEDivineRod() : base() {
		$this.Name          = 'Divine Rod'
		$this.MapObjName    = 'divinerod'
		$this.PurchasePrice = 3800
		$this.SellPrice     = 1900
		$this.TargetStats   = @{
			[StatId]::Attack      = 10
			[StatId]::MagicAttack = 95
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rod imbued with holy power, granting blessings to allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
