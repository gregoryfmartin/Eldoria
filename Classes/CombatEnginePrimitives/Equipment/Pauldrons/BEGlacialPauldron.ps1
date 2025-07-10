using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLACIALPAULDRON
#
###############################################################################

Class BEGlacialPauldron : BEPauldron {
	BEGlacialPauldron() : base() {
		$this.Name               = 'Glacial Pauldron'
		$this.MapObjName         = 'glacialpauldron'
		$this.PurchasePrice      = 3700
		$this.SellPrice          = 1850
		$this.TargetStats        = @{
			[StatId]::Defense = 74
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Freezes anything that touches it, offering resistance to ice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
