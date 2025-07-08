using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE TITAN AXE
#
###############################################################################

Class BETitanAxe : BEWeapon {
	BETitanAxe() : base() {
		$this.Name          = 'Titan Axe'
		$this.MapObjName    = 'titanaxe'
		$this.PurchasePrice = 1300
		$this.SellPrice     = 650
		$this.TargetStats   = @{
			[StatId]::Attack = 68
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal axe, said to be wielded by giants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
