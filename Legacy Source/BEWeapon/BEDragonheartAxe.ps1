using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONHEARTAXE
#
###############################################################################

Class BEDragonheartAxe : BEWeapon {
	BEDragonheartAxe() : base() {
		$this.Name          = 'Dragonheart Axe'
		$this.MapObjName    = 'dragonheartaxe'
		$this.PurchasePrice = 6200
		$this.SellPrice     = 3100
		$this.TargetStats   = @{
			[StatId]::Attack      = 155
			[StatId]::MagicAttack = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe embedded with a dragon''s heart, pulsating with power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
