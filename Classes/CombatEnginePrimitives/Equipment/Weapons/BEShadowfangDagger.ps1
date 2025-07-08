using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SHADOWFANG DAGGER
#
###############################################################################

Class BEShadowfangDagger : BEWeapon {
	BEShadowfangDagger() : base() {
		$this.Name          = 'Shadowfang Dagger'
		$this.MapObjName    = 'shadowfangdagger'
		$this.PurchasePrice = 3500
		$this.SellPrice     = 1750
		$this.TargetStats   = @{
			[StatId]::Attack      = 85
			[StatId]::MagicAttack = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger that drains shadows from enemies, making them vulnerable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
