using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONBONEAXE
#
###############################################################################

Class BEDragonboneAxe : BEWeapon {
	BEDragonboneAxe() : base() {
		$this.Name          = 'Dragonbone Axe'
		$this.MapObjName    = 'dragonboneaxe'
		$this.PurchasePrice = 4600
		$this.SellPrice     = 2300
		$this.TargetStats   = @{
			[StatId]::Attack = 112
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe made from the bone of an ancient dragon, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
