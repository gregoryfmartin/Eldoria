using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SOULREND
#
###############################################################################

Class BESoulrend : BEWeapon {
	BESoulrend() : base() {
		$this.Name          = 'Soulrend'
		$this.MapObjName    = 'soulrend'
		$this.PurchasePrice = 5300
		$this.SellPrice     = 2650
		$this.TargetStats   = @{
			[StatId]::Attack      = 138
			[StatId]::MagicAttack = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that tears at the very fabric of an enemy''s being.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
