using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GUARDIAN SHIELD
#
###############################################################################

Class BEGuardianShield : BEWeapon {
	BEGuardianShield() : base() {
		$this.Name          = 'Guardian Shield'
		$this.MapObjName    = 'guardianshield'
		$this.PurchasePrice = 700
		$this.SellPrice     = 350
		$this.TargetStats   = @{
			[StatId]::Attack = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shield that can also be used as a blunt weapon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
