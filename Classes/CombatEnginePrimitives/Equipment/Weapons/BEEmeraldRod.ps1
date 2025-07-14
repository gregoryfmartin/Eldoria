using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMERALDROD
#
###############################################################################

Class BEEmeraldRod : BEWeapon {
	BEEmeraldRod() : base() {
		$this.Name          = 'Emerald Rod'
		$this.MapObjName    = 'emeraldrod'
		$this.PurchasePrice = 750
		$this.SellPrice     = 375
		$this.TargetStats   = @{
			[StatId]::Attack      = 10
			[StatId]::MagicAttack = 44
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rod adorned with a shimmering emerald, boosting earth magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
