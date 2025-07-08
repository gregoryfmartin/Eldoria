using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DRAGONS BANE
#
###############################################################################

Class BEDragonsBane : BEWeapon {
	BEDragonsBane() : base() {
		$this.Name          = 'Dragon''s Bane'
		$this.MapObjName    = 'dragonsbane'
		$this.PurchasePrice = 6200
		$this.SellPrice     = 3100
		$this.TargetStats   = @{
			[StatId]::Attack      = 148
			[StatId]::MagicAttack = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword specifically designed to hunt and slay dragons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
