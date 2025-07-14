using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHUNDERFURY
#
###############################################################################

Class BEThunderfury : BEWeapon {
	BEThunderfury() : base() {
		$this.Name          = 'Thunderfury'
		$this.MapObjName    = 'thunderfury'
		$this.PurchasePrice = 6900
		$this.SellPrice     = 3450
		$this.TargetStats   = @{
			[StatId]::Attack      = 165
			[StatId]::MagicAttack = 80
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary sword that roars with lightning, striking multiple foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
