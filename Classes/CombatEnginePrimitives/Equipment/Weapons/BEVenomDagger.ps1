using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VENOM DAGGER
#
###############################################################################

Class BEVenomDagger : BEWeapon {
	BEVenomDagger() : base() {
		$this.Name          = 'Venom Dagger'
		$this.MapObjName    = 'venomdagger'
		$this.PurchasePrice = 650
		$this.SellPrice     = 325
		$this.TargetStats   = @{
			[StatId]::Attack = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger coated in potent poison, inflicting continuous damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
