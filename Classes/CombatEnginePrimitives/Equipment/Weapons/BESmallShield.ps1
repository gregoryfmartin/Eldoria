using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESMALLSHIELD
#
###############################################################################

Class BESmallShield : BEWeapon {
	BESmallShield() : base() {
		$this.Name          = 'Small Shield'
		$this.MapObjName    = 'smallshield'
		$this.PurchasePrice = 70
		$this.SellPrice     = 35
		$this.TargetStats   = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A very small shield, offers minimal protection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
