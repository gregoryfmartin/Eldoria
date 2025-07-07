using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BLOWGUN
#
###############################################################################

Class BEBlowgun : BEWeapon {
	BEBlowgun() : base() {
		$this.Name          = 'Blowgun'
		$this.MapObjName    = 'blowgun'
		$this.PurchasePrice = 90
		$this.SellPrice     = 45
		$this.TargetStats   = @{
			[StatId]::Attack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A long tube for shooting darts. Requires darts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
