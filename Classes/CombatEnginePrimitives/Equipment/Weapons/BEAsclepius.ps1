using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ASCLEPIUS
#
###############################################################################

Class BEAsclepius : BEWeapon {
	BEAsclepius() : base() {
		$this.Name          = 'Asclepius'
		$this.MapObjName    = 'asclepius'
		$this.PurchasePrice = 4000
		$this.SellPrice     = 2000
		$this.TargetStats   = @{
			[StatId]::Attack      = 20
			[StatId]::MagicAttack = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff with healing powers, capable of curing all ailments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
