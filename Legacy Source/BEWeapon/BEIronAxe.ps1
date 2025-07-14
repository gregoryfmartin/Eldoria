using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONAXE
#
###############################################################################

Class BEIronAxe : BEWeapon {
	BEIronAxe() : base() {
		$this.Name          = 'Iron Axe'
		$this.MapObjName    = 'ironaxe'
		$this.PurchasePrice = 150
		$this.SellPrice     = 75
		$this.TargetStats   = @{
			[StatId]::Attack = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy iron axe, effective against armored foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
