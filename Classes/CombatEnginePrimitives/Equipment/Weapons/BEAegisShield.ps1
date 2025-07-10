using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAEGISSHIELD
#
###############################################################################

Class BEAegisShield : BEWeapon {
	BEAegisShield() : base() {
		$this.Name          = 'Aegis Shield'
		$this.MapObjName    = 'aegisshield'
		$this.PurchasePrice = 3500
		$this.SellPrice     = 1750
		$this.TargetStats   = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A divine shield that reflects all magical attacks.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
