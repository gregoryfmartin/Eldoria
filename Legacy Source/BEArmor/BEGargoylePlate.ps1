using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGARGOYLEPLATE
#
###############################################################################

Class BEGargoylePlate : BEArmor {
	BEGargoylePlate() : base() {
		$this.Name               = 'Gargoyle Plate'
		$this.MapObjName         = 'gargoyleplate'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::Defense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, grotesque plate armor carved to resemble a gargoyle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
