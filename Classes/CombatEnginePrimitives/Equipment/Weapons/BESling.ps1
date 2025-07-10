using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESLING
#
###############################################################################

Class BESling : BEWeapon {
	BESling() : base() {
		$this.Name          = 'Sling'
		$this.MapObjName    = 'sling'
		$this.PurchasePrice = 40
		$this.SellPrice     = 20
		$this.TargetStats   = @{
			[StatId]::Attack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple projectile weapon, uses small stones as ammo.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
