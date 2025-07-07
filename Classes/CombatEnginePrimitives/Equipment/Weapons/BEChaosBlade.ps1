using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CHAOS BLADE
#
###############################################################################

Class BEChaosBlade : BEWeapon {
	BEChaosBlade() : base() {
		$this.Name          = 'Chaos Blade'
		$this.MapObjName    = 'chaosblade'
		$this.PurchasePrice = 1250
		$this.SellPrice     = 625
		$this.TargetStats   = @{
			[StatId]::Attack      = 58
			[StatId]::MagicAttack = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that possesses unpredictable magical effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
