using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTPAULDRON
#
###############################################################################

Class BEFrostPauldron : BEPauldron {
	BEFrostPauldron() : base() {
		$this.Name               = 'Frost Pauldron'
		$this.MapObjName         = 'frostpauldron'
		$this.PurchasePrice      = 3750
		$this.SellPrice          = 1875
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Covered in perpetual frost, enhancing ice-based defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
