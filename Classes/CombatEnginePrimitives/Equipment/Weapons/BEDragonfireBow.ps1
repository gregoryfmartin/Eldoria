using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DRAGONFIRE BOW
#
###############################################################################

Class BEDragonfireBow : BEWeapon {
	BEDragonfireBow() : base() {
		$this.Name          = 'Dragonfire Bow'
		$this.MapObjName    = 'dragonfirebow'
		$this.PurchasePrice = 6000
		$this.SellPrice     = 3000
		$this.TargetStats   = @{
			[StatId]::Attack      = 132
			[StatId]::MagicAttack = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that imbues arrows with dragonfire, causing explosive impacts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
