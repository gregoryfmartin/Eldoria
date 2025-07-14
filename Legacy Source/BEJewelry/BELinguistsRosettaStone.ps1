using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELINGUISTSROSETTASTONE
#
###############################################################################

Class BELinguistsRosettaStone : BEJewelry {
	BELinguistsRosettaStone() : base() {
		$this.Name               = 'Linguist''s Rosetta Stone'
		$this.MapObjName         = 'linguistsrosettastone'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small fragment resembling the Rosetta Stone, for understanding languages.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
