using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAEGISDEFENDER
#
###############################################################################

Class BEAegisDefender : BEWeapon {
	BEAegisDefender() : base() {
		$this.Name          = 'Aegis Defender'
		$this.MapObjName    = 'aegisdefender'
		$this.PurchasePrice = 5500
		$this.SellPrice     = 2750
		$this.TargetStats   = @{
			[StatId]::Attack = 130
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A weaponized shield capable of powerful bash attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
