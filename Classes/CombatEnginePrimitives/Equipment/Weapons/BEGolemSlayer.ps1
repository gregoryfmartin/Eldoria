using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMSLAYER
#
###############################################################################

Class BEGolemSlayer : BEWeapon {
	BEGolemSlayer() : base() {
		$this.Name          = 'Golem Slayer'
		$this.MapObjName    = 'golemslayer'
		$this.PurchasePrice = 3600
		$this.SellPrice     = 1800
		$this.TargetStats   = @{
			[StatId]::Attack = 90
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A specialized weapon designed to destroy constructs and golems.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
