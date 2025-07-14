using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONPETALBOW
#
###############################################################################

Class BEMoonpetalBow : BEWeapon {
	BEMoonpetalBow() : base() {
		$this.Name          = 'Moonpetal Bow'
		$this.MapObjName    = 'moonpetalbow'
		$this.PurchasePrice = 3900
		$this.SellPrice     = 1950
		$this.TargetStats   = @{
			[StatId]::Attack      = 98
			[StatId]::MagicAttack = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow strung with moonpetal fibers, firing arrows of pure moonlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
