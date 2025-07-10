using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIFFINFEATHERVEST
#
###############################################################################

Class BEGriffinFeatherVest : BEArmor {
	BEGriffinFeatherVest() : base() {
		$this.Name               = 'Griffin Feather Vest'
		$this.MapObjName         = 'griffinfeathervest'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from the feathers of a griffin, allows for light fall.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
