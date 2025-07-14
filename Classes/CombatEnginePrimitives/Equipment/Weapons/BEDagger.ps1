using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDAGGER
#
###############################################################################

Class BEDagger : BEWeapon {
	BEDagger() : base() {
		$this.Name          = 'Dagger'
		$this.MapObjName    = 'dagger'
		$this.PurchasePrice = 75
		$this.SellPrice     = 37
		$this.TargetStats   = @{
			[StatId]::Attack = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, sharp blade for quick attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
