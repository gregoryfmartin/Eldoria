using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CHAOS BOW
#
###############################################################################

Class BEChaosBow : BEWeapon {
	BEChaosBow() : base() {
		$this.Name          = 'Chaos Bow'
		$this.MapObjName    = 'chaosbow'
		$this.PurchasePrice = 4000
		$this.SellPrice     = 2000
		$this.TargetStats   = @{
			[StatId]::Attack      = 95
			[StatId]::MagicAttack = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that fires unpredictable magical arrows, sometimes devastating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
