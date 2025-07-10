using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTURDYSTICK
#
###############################################################################

Class BESturdyStick : BEWeapon {
	BESturdyStick() : base() {
		$this.Name          = 'Sturdy Stick'
		$this.MapObjName    = 'sturdystick'
		$this.PurchasePrice = 30
		$this.SellPrice     = 15
		$this.TargetStats   = @{
			[StatId]::Attack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A thick, durable branch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
