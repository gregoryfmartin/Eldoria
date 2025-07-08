using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SOULFLAME SCYTHE
#
###############################################################################

Class BESoulflameScythe : BEWeapon {
	BESoulflameScythe() : base() {
		$this.Name          = 'Soulflame Scythe'
		$this.MapObjName    = 'soulflamescythe'
		$this.PurchasePrice = 6500
		$this.SellPrice     = 3250
		$this.TargetStats   = @{
			[StatId]::Attack      = 150
			[StatId]::MagicAttack = 80
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scythe that burns with an ethereal flame, consuming enemy souls.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
