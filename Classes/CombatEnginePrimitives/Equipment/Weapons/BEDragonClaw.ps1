using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DRAGON CLAW
#
###############################################################################

Class BEDragonClaw : BEWeapon {
	BEDragonClaw() : base() {
		$this.Name          = 'Dragon Claw'
		$this.MapObjName    = 'dragonclaw'
		$this.PurchasePrice = 4600
		$this.SellPrice     = 2300
		$this.TargetStats   = @{
			[StatId]::Attack = 118
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gauntlet designed to mimic a dragon''s claw, crushing foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
