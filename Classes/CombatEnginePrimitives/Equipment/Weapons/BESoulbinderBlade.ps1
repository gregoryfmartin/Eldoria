using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULBINDERBLADE
#
###############################################################################

Class BESoulbinderBlade : BEWeapon {
	BESoulbinderBlade() : base() {
		$this.Name          = 'Soulbinder Blade'
		$this.MapObjName    = 'soulbinderblade'
		$this.PurchasePrice = 5800
		$this.SellPrice     = 2900
		$this.TargetStats   = @{
			[StatId]::Attack      = 135
			[StatId]::MagicAttack = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blade that can temporarily bind an enemy''s movements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
