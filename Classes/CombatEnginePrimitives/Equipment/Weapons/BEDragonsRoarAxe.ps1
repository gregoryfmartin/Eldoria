using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DRAGONS ROAR AXE
#
###############################################################################

Class BEDragonsRoarAxe : BEWeapon {
	BEDragonsRoarAxe() : base() {
		$this.Name          = 'Dragon''s Roar Axe'
		$this.MapObjName    = 'dragonsroaraxe'
		$this.PurchasePrice = 6000
		$this.SellPrice     = 3000
		$this.TargetStats   = @{
			[StatId]::Attack      = 148
			[StatId]::MagicAttack = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that can unleash a sonic roar, disorienting enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
