using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILVERPLATEARMOR
#
###############################################################################

Class BESilverPlateArmor : BEArmor {
	BESilverPlateArmor() : base() {
		$this.Name               = 'Silver Plate Armor'
		$this.MapObjName         = 'silverplatearmor'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor forged from pure silver, shines brightly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
