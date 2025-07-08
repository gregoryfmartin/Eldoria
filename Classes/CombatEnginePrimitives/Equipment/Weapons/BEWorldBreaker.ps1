using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WORLD BREAKER
#
###############################################################################

Class BEWorldBreaker : BEWeapon {
	BEWorldBreaker() : base() {
		$this.Name          = 'World Breaker'
		$this.MapObjName    = 'worldbreaker'
		$this.PurchasePrice = 5500
		$this.SellPrice     = 2750
		$this.TargetStats   = @{
			[StatId]::Attack = 150
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal hammer said to shatter mountains.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
