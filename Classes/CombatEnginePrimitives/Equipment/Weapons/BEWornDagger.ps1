using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WORN DAGGER
#
###############################################################################

Class BEWornDagger : BEWeapon {
	BEWornDagger() : base() {
		$this.Name          = 'Worn Dagger'
		$this.MapObjName    = 'worndagger'
		$this.PurchasePrice = 35
		$this.SellPrice     = 17
		$this.TargetStats   = @{
			[StatId]::Attack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A used and dulled dagger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
