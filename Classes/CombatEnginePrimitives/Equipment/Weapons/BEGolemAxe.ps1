using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMAXE
#
###############################################################################

Class BEGolemAxe : BEWeapon {
	BEGolemAxe() : base() {
		$this.Name          = 'Golem Axe'
		$this.MapObjName    = 'golemaxe'
		$this.PurchasePrice = 1020
		$this.SellPrice     = 510
		$this.TargetStats   = @{
			[StatId]::Attack = 61
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe designed to shatter stone and metal, incredibly heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
