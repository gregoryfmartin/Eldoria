using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARRIERBLADE
#
###############################################################################

Class BEBarrierBlade : BEWeapon {
	BEBarrierBlade() : base() {
		$this.Name          = 'Barrier Blade'
		$this.MapObjName    = 'barrierblade'
		$this.PurchasePrice = 850
		$this.SellPrice     = 425
		$this.TargetStats   = @{
			[StatId]::Attack      = 42
			[StatId]::MagicAttack = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that can temporarily create a magical shield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
