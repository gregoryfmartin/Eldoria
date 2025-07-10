using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEAVYLEATHERARMOR
#
###############################################################################

Class BEHeavyLeatherArmor : BEArmor {
	BEHeavyLeatherArmor() : base() {
		$this.Name               = 'Heavy Leather Armor'
		$this.MapObjName         = 'heavyleatherarmor'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Thick layers of leather for enhanced defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
