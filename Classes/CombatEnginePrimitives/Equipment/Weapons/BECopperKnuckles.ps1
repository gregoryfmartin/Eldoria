using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE COPPER KNUCKLES
#
###############################################################################

Class BECopperKnuckles : BEWeapon {
	BECopperKnuckles() : base() {
		$this.Name          = 'Copper Knuckles'
		$this.MapObjName    = 'copperknuckles'
		$this.PurchasePrice = 80
		$this.SellPrice     = 40
		$this.TargetStats   = @{
			[StatId]::Attack = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Metal plates worn over the knuckles to enhance punches.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
