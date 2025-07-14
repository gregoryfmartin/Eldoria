using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDARKNESSBOW
#
###############################################################################

Class BEDarknessBow : BEWeapon {
	BEDarknessBow() : base() {
		$this.Name          = 'Darkness Bow'
		$this.MapObjName    = 'darknessbow'
		$this.PurchasePrice = 980
		$this.SellPrice     = 490
		$this.TargetStats   = @{
			[StatId]::Attack      = 52
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that fires arrows of pure shadow, obscuring vision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
