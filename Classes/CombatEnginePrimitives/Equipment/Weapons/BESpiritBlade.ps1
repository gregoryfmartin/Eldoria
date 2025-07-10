using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITBLADE
#
###############################################################################

Class BESpiritBlade : BEWeapon {
	BESpiritBlade() : base() {
		$this.Name          = 'Spirit Blade'
		$this.MapObjName    = 'spiritblade'
		$this.PurchasePrice = 1080
		$this.SellPrice     = 540
		$this.TargetStats   = @{
			[StatId]::Attack      = 54
			[StatId]::MagicAttack = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that can harm incorporeal beings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
