using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ICE BRAND
#
###############################################################################

Class BEIceBrand : BEWeapon {
	BEIceBrand() : base() {
		$this.Name          = 'Ice Brand'
		$this.MapObjName    = 'icebrand'
		$this.PurchasePrice = 780
		$this.SellPrice     = 390
		$this.TargetStats   = @{
			[StatId]::Attack      = 48
			[StatId]::MagicAttack = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword imbued with the essence of ice, capable of freezing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
