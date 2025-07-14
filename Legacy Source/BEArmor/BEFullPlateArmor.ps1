using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFULLPLATEARMOR
#
###############################################################################

Class BEFullPlateArmor : BEArmor {
	BEFullPlateArmor() : base() {
		$this.Name               = 'Full Plate Armor'
		$this.MapObjName         = 'fullplatearmor'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Complete and heavy plate armor, offering superior defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
