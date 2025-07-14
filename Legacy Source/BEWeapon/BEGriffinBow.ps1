using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIFFINBOW
#
###############################################################################

Class BEGriffinBow : BEWeapon {
	BEGriffinBow() : base() {
		$this.Name          = 'Griffin Bow'
		$this.MapObjName    = 'griffinbow'
		$this.PurchasePrice = 1300
		$this.SellPrice     = 650
		$this.TargetStats   = @{
			[StatId]::Attack = 65
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow crafted from griffin feathers, offering incredible range and speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
