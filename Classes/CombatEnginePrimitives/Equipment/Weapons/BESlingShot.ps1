using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SLING SHOT
#
###############################################################################

Class BESlingShot : BEWeapon {
	BESlingShot() : base() {
		$this.Name          = 'Sling Shot'
		$this.MapObjName    = 'slingshot'
		$this.PurchasePrice = 80
		$this.SellPrice     = 40
		$this.TargetStats   = @{
			[StatId]::Attack = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A more powerful version of a sling.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
