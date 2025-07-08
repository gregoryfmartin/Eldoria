using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE EMERALD BOW
#
###############################################################################

Class BEEmeraldBow : BEWeapon {
	BEEmeraldBow() : base() {
		$this.Name          = 'Emerald Bow'
		$this.MapObjName    = 'emeraldbow'
		$this.PurchasePrice = 4100
		$this.SellPrice     = 2050
		$this.TargetStats   = @{
			[StatId]::Attack      = 102
			[StatId]::MagicAttack = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow adorned with gleaming emeralds, increasing precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
