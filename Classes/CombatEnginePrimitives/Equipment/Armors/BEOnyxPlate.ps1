using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEONYXPLATE
#
###############################################################################

Class BEOnyxPlate : BEArmor {
	BEOnyxPlate() : base() {
		$this.Name               = 'Onyx Plate'
		$this.MapObjName         = 'onyxplate'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor crafted from polished black onyx, very heavy and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
