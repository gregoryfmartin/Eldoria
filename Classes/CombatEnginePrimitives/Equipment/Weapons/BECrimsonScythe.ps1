using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CRIMSON SCYTHE
#
###############################################################################

Class BECrimsonScythe : BEWeapon {
	BECrimsonScythe() : base() {
		$this.Name          = 'Crimson Scythe'
		$this.MapObjName    = 'crimsonscythe'
		$this.PurchasePrice = 4700
		$this.SellPrice     = 2350
		$this.TargetStats   = @{
			[StatId]::Attack      = 115
			[StatId]::MagicAttack = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scythe stained crimson, rumored to drink blood.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
