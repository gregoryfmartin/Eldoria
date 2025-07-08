using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SUNSTONE BOW
#
###############################################################################

Class BESunstoneBow : BEWeapon {
	BESunstoneBow() : base() {
		$this.Name          = 'Sunstone Bow'
		$this.MapObjName    = 'sunstonebow'
		$this.PurchasePrice = 5800
		$this.SellPrice     = 2900
		$this.TargetStats   = @{
			[StatId]::Attack      = 128
			[StatId]::MagicAttack = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that gathers solar energy, firing explosive arrows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
