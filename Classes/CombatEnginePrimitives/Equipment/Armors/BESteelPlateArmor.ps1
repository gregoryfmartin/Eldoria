using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEELPLATEARMOR
#
###############################################################################

Class BESteelPlateArmor : BEArmor {
	BESteelPlateArmor() : base() {
		$this.Name               = 'Steel Plate Armor'
		$this.MapObjName         = 'steelplatearmor'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and reliable steel plate armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
