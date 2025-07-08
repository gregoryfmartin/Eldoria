using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE EXCALIBUR
#
###############################################################################

Class BEExcalibur : BEWeapon {
	BEExcalibur() : base() {
		$this.Name          = 'Excalibur'
		$this.MapObjName    = 'excalibur'
		$this.PurchasePrice = 5000
		$this.SellPrice     = 2500
		$this.TargetStats   = @{
			[StatId]::Attack      = 120
			[StatId]::MagicAttack = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary sword said to be forged by the gods, grants immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
