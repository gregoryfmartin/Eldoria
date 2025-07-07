using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MANA ROD
#
###############################################################################

Class BEManaRod : BEWeapon {
	BEManaRod() : base() {
		$this.Name          = 'Mana Rod'
		$this.MapObjName    = 'manarod'
		$this.PurchasePrice = 600
		$this.SellPrice     = 300
		$this.TargetStats   = @{
			[StatId]::Attack      = 5
			[StatId]::MagicAttack = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple rod that helps regenerate mana.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
